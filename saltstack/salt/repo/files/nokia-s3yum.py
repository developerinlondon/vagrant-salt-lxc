"""
Yum plugin for Amazon S3 access.

This plugin provides access to a protected Amazon S3 bucket using Amazon's REST authentication scheme.

A modified version of the yum-s3-plugin :  https://github.com/jbraeuer/yum-s3-plugin
Major changes are to reintroduce support for https server authentication, removing all dependency on python-boto, and supporting IAM Roles.

On CentOS this file goes into /usr/lib/yum-plugins/nokia-s3yum.py

You will also need two configuration files.   See nokia-s3yum.conf and nokia-s3yum-example.repo for
examples on how to deploy those.


"""

#   Copyright 2011, Robert Mela
#   Copyright 2011, Jens Braeuer
#   Copyright 2011-2012, Nokia Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import logging
import os
import urlgrabber
import datetime

from yum.plugins import TYPE_CORE
from yum.yumRepo import YumRepository
from yum import config

CRED_META = 'http://169.254.169.254/latest/meta-data/iam/security-credentials/'

def createGrabber():
    """
    Fetch files from AWS (without python-boto) using Amazon's REST API.
    """
    import base64
    import hashlib
    import hmac
    import json
    import re
    import time
    import traceback
    import urllib
    import urlparse

    from urlgrabber.grabber import URLGrabber

    class S3Grabber:
        logger = logging.getLogger("yum.verbose.main")

        def __init__(self, repoid, awsAccessKey, awsSecretKey, iamRole, baseurl):
            if type(baseurl) == list:
                baseurl = baseurl[0]
            if not baseurl.endswith("/"):
                baseurl = baseurl + "/"

            self.repoid = repoid
            self.baseurl = baseurl
            self.delegate = URLGrabber(prefix=self.baseurl)
            self.awsAccessKey = awsAccessKey
            self.awsSecretKey = awsSecretKey
            self.iamRole = iamRole
            self.parsedUrl = urlparse.urlparse(self.baseurl)
            match = re.match('(.*)\.s3.*?\.amazonaws\.com', self.parsedUrl.hostname)
            if match:
                self.bucket = match.group(1)
            else:
                raise Exception("Host in baseurl must be of form BUCKETNAME.s3.amazonaws.com or BUCKETNAME.s3-region.amazonaws.com: %s" % self.parsedUrl.hostname)

            # find our region required for V4 request signing
            match = re.match('.*\.s3-(\w\w-\w+-\d)\.amazonaws.com', self.parsedUrl.hostname)
            if not match: # try looking at our bucketname
                match = re.match('(\w\w-\w+-\d)', self.bucket)

            if match:
                self.region = match.group(1)
            else:
                self.region = 'us-east-1' # our default if no region specified

            self.logger.debug("S3Grabber[%s].__init__ baseurl=%s bucket=%s accessKey=%s iamRole=%s" % (self.repoid, self.baseurl, self.bucket, self.awsAccessKey, self.iamRole))

        # v4 signing method
        def sign(self, key, msg):
            return hmac.new(key, msg.encode('utf-8'), hashlib.sha256).digest()

        # v4 signing method
        def getSignatureKey(self, key, dateStamp, regionName, serviceName):
            kDate = self.sign(('AWS4' + key).encode('utf-8'), dateStamp)
            kRegion = self.sign(kDate, regionName)
            kService = self.sign(kRegion, serviceName)
            kSigning = self.sign(kService, 'aws4_request')
            return kSigning

        # adopted from http://docs.aws.amazon.com/general/latest/gr/sigv4-signed-request-examples.html
        def _s3signV4(self, baseurl, url, **kwargs):
            self.logger.debug("Signing %s/%s with AWS V4 Signature" % (baseurl,url)) 
            url_to_parse = baseurl + url
            # prevent double slashes - I don't think this causes a problem, but
            # it certainly won't cause any
            if baseurl[-1:] == '/' and url[0] == '/':
                url_to_parse = baseurl[:-1] + url
            
            parsedReq = urlparse.urlparse(url_to_parse)
            if self.iamRole:
                cred = self._get_credentials()
                access_key = cred['AccessKeyId'].encode('ascii')
                secret_key = cred['SecretAccessKey'].encode('ascii')
                token = cred['Token'].encode('ascii')
            elif self.awsAccessKey and self.awsSecretKey:
                access_key = self.awsAccessKey
                secret_key = self.awsSecretKey
                token = None
            else:
                raise Exception("no AWS credentials available")


            method = 'GET'
            region = self.region
            service = 's3'
            host = parsedReq.hostname
            request_parameters = ""
            t = datetime.datetime.utcnow()
            amzdate = t.strftime('%Y%m%dT%H%M%SZ')
            datestamp = t.strftime('%Y%m%d')
            canonical_uri = urllib.quote(parsedReq.path)
            canonical_querystring = ''
            payload_hash = hashlib.sha256('').hexdigest()
            canonical_headers = 'host:' + host + '\n' + 'x-amz-content-sha256:' + payload_hash + '\n' + 'x-amz-date:' + amzdate + '\n'
            signed_headers = 'host;x-amz-content-sha256;x-amz-date'
            headers = ()
            if token:
                headers += ( ('x-amz-security-token', token),)
                canonical_headers += 'x-amz-security-token:' + token + '\n'
                signed_headers = "%s;x-amz-security-token" % (signed_headers)

            canonical_request = method + '\n' + canonical_uri + '\n' + canonical_querystring + '\n' + canonical_headers + '\n' + signed_headers + '\n' + payload_hash
            self.logger.debug("V4 Canonical Request: %s" % (canonical_request))
            algorithm = 'AWS4-HMAC-SHA256'
            #access key is prefixed later
            credential_scope = datestamp + '/' + region + '/' + service + '/' + 'aws4_request'
            string_to_sign = algorithm + '\n' +  amzdate + '\n' +  credential_scope + '\n' +  hashlib.sha256(canonical_request).hexdigest()
            self.logger.debug("V4 String to Sign: %s" % (string_to_sign))
            signing_key = self.getSignatureKey(secret_key, datestamp, region, service)
            signature = hmac.new(signing_key, (string_to_sign).encode('utf-8'), hashlib.sha256).hexdigest()
            authorization_header = algorithm + ' ' + 'Credential=' + access_key + '/' + credential_scope + ', ' +  'SignedHeaders=' + signed_headers + ', ' + 'Signature=' + signature
            headers += ( ('Host', host), ('x-amz-content-sha256', payload_hash ), ('x-amz-date', amzdate), ('Authorization', authorization_header), )

            self.logger.debug("URL Grab headers: %s" % (str(headers)))
            kwargs['http_headers'] = headers
            return kwargs
    
       
        def _s3sign(self, url, **kwargs):
            parsedReq = urlparse.urlparse(url)

            if self.iamRole:
                cred = self._get_credentials()
                key = cred['AccessKeyId'].encode('ascii')
                secret = cred['SecretAccessKey'].encode('ascii')
                token = cred['Token'].encode('ascii')
            elif self.awsAccessKey and self.awsSecretKey:
                key = self.awsAccessKey
                secret = self.awsSecretKey
                token = None
            else:
                raise Exception("no AWS credentials available")

            date = time.strftime("%a, %d %b %Y %H:%M:%S +0000", time.gmtime())
            resource = "/%s%s%s" % (self.bucket, urllib.quote(self.parsedUrl.path), urllib.quote(parsedReq.path))
            headers = ( ('Date', date), )
            if token:
                hdr = ('x-amz-security-token', token)
                headers += ( hdr, )
                sighdrs = '%s:%s\n' % hdr
            else:
                sighdrs = ''
            sigstring = """%(method)s\n\n\n%(date)s\n%(canon_amzn_headers)s%(canon_amzn_resource)s""" % {
                                       'method': 'GET',
                                       'date': date,
                                       'canon_amzn_headers': sighdrs,
                                       'canon_amzn_resource': resource}

            digest = hmac.new(secret, sigstring, hashlib.sha1).digest()
            digest = base64.b64encode(digest)

            headers += ( ('Authorization', "AWS %s:%s" % (key, digest)), )

            kwargs['http_headers'] = headers
            return kwargs

        def _get_credentials(self):
            try:
                f = urlgrabber.urlopen(CRED_META + self.iamRole)
                try:
                    return json.load(f)
                finally:
                    f.close()
            except Exception as e:
                raise Exception("failed to obtain credentials for IAM Role %s: %s" % (self.iamRole, e.strerror))

        def urlgrab(self, url, filename=None, **kwargs):
            """urlgrab(url) copy the file to the local filesystem"""
            self.logger.debug("S3Grabber[%s].urlgrab url=[%s]%s filename=%s" % (self.repoid, self.baseurl, url, filename))
            try:
                params = self._s3signV4(self.baseurl, url, **kwargs)
                return self.delegate.urlgrab(url, filename, **params)
            except:
                self.logger.debug("S3Grabber[%s].urlgrab failure - %s" % (self.repoid, traceback.format_exc())) 
                print open(filename).read()
                raise

        def urlopen(self, url, **kwargs):
            self.logger.debug("S3Grabber[%s].urlopen url=[%s]%s " % (self.repoid, self.baseurl, url))
            try:
                params = self._s3signV4(self.baseurl, url, **kwargs)
                return self.delegate.urlopen(url, **params)
            except:
                self.logger.debug("S3Grabber[%s].urlopen failure - %s" % (self.repoid, traceback.format_exc()))
                raise

        def urlread(self, url, limit=None, **kwargs):
            """urlread(url) return the contents of the file as a string"""
            self.logger.debug("S3Grabber[%s].urlread url=[%s]%s limit=%s" % (self.repoid, self.baseurl, url, limit))
            try:
                params = self._s3signV4(self.baseurl, url, **kwargs)
                return self.delegate.urlread(url, limit, **params)
            except:
                self.logger.debug("S3Grabber[%s].urlread failure - %s" % (self.repoid, traceback.format_exc()))
                raise

    return S3Grabber

AmazonS3Grabber = createGrabber()

class AmazonS3Repo(YumRepository):
    """
    Repository object for Amazon S3.
    """

    def __init__(self, repoid):
        YumRepository.__init__(self, repoid)
        self.grabber = None

    def setupGrab(self):
        YumRepository.setupGrab(self)
        self.grabber = AmazonS3Grabber(self.id, self.key_id, self.secret_key, self.iam_role)

    def _getgrab(self):
        if not self.grabber:
            self.grabber = AmazonS3Grabber(self.id, self.key_id, self.secret_key, self.iam_role, baseurl=self.baseurl)
        return self.grabber

    grabfunc = property(lambda self: self._getgrabfunc())
    grab = property(lambda self: self._getgrab())


__revision__ = "1.1.2"
requires_api_version = '2.5'
plugin_type = TYPE_CORE

credentials_envvar = "AWS_CREDENTIAL_FILE"
iam_role_envvar = "IAM_ROLE"
logger = logging.getLogger("yum.verbose.main")

def config_hook(conduit):
    config.RepoConf.s3_enabled = config.BoolOption(False)
    config.RepoConf.key_id = conduit.confString('main', 'aws_access_key_id') or config.Option()
    config.RepoConf.secret_key = conduit.confString('main', 'aws_secret_access_key') or config.Option()
    iamRole = get_iam_role(os.getenv(iam_role_envvar) or conduit.confString('main', 'iam_role'))

    if iamRole:
        logger.debug("Found IAM Role = %s" % iamRole)
        config.RepoConf.iam_role = iamRole
        return
    config.RepoConf.iam_role = config.Option()
    credFile = os.getenv(credentials_envvar)
    if credFile:
        logger.debug("Found env %s = %s" % (credentials_envvar, credFile))
        try:
            parsedProps = parse_credentials_file(credFile)
            key_id = parsedProps.get("AWSAccessKeyId", None)
            if key_id is None:
                logger.warn("OOPS: %s file %s parsed, but AWSAccessKeyId not found" % (credentials_envvar, credFile))
            else:
                config.RepoConf.key_id = key_id
            secret_key = parsedProps.get("AWSSecretKey", None)
            if secret_key is None:
                logger.warn("OOPS: %s file %s parsed, but AWSSecretKey not found" % (credentials_envvar, credFile))
            else:
                config.RepoConf.secret_key = secret_key
        except IOError as ioe:
            logger.warn("OOPS: problem parsing %s file %s: %s" % (credentials_envvar, credFile, ioe.strerror))

def init_hook(conduit):
    """
    Plugin initialization hook. Setup the S3 repositories.
    """

    repos = conduit.getRepos()

    for key,repo in repos.repos.iteritems():
        if isinstance(repo, YumRepository) and hasattr(repo, "s3_enabled") and repo.s3_enabled:
            logger.debug("Yum repo %s is s3_enabled, hooking in S3 authentication" % key)
            new_repo = AmazonS3Repo(key)
            new_repo.name = repo.name
            new_repo.baseurl = repo.baseurl
            new_repo.mirrorlist = repo.mirrorlist
            if hasattr(repo, "base_persistdir"):
                new_repo.base_persistdir = repo.base_persistdir
            new_repo.basecachedir = repo.basecachedir
            new_repo.gpgcheck = repo.gpgcheck
            new_repo.proxy = repo.proxy
            new_repo.enablegroups = repo.enablegroups
            new_repo.key_id = repo.key_id
            new_repo.secret_key = repo.secret_key
            new_repo.iam_role = get_iam_role(repo.iam_role)
            new_repo.enabled = repo.enabled
            new_repo.metadata_expire = repo.metadata_expire
            new_repo.cfg = repo.cfg
            new_repo.repofile = repo.repofile

            repos.delete(repo.id)
            repos.add(new_repo)

def get_iam_role(iamRole):
    if iamRole == '1':
        try:
            iamRole = urlgrabber.urlread(CRED_META).splitlines()[0]
            logger.debug("Resolved IAM Role = %s" % iamRole)
        except Exception as e:
            logger.warn("OOPS: failed to obtain IAM Role metadata: %s" % e.strerror)
            iamRole = None
    return iamRole

def parse_credentials_file(filename):
    props = {}
    with open(filename , 'rb') as credFile:
        for line in credFile:
            key, value = line.partition("=")[::2]
            key = key.strip()
            if not key.startswith(("#", "!")):
                props[key] = value.strip()
    return props
