//
//  CURLConnection.m
//  FinTech
//
//  Created by Bálint Róbert on 30/07/15.
//  Copyright (c) 2015 IncepTech Ltd. All rights reserved.
//

#import "CURLConnection.h"
#import "UtilMacros.h"
#import "curl.h"

#define CURL_MAKE_CODE(cdx) {cdx, #cdx, NULL}
#define CURL_MAKE_CODE2(cdx, ext) {cdx, #cdx, ext}

typedef struct {
    CURLcode code;
    const char *description;
    const char *extra;
} curlErrorCodes_s;

curlErrorCodes_s curlCodes[] = {
    CURL_MAKE_CODE(CURLE_OK),
    CURL_MAKE_CODE(CURLE_UNSUPPORTED_PROTOCOL),
    CURL_MAKE_CODE(CURLE_FAILED_INIT),
    CURL_MAKE_CODE(CURLE_URL_MALFORMAT),
    CURL_MAKE_CODE2(CURLE_NOT_BUILT_IN,             "[was obsoleted in August 2007 for 7.17.0, reused in April 2011 for 7.21.5]"),
    CURL_MAKE_CODE(CURLE_COULDNT_RESOLVE_PROXY),
    CURL_MAKE_CODE(CURLE_COULDNT_RESOLVE_HOST),
    CURL_MAKE_CODE(CURLE_COULDNT_CONNECT),
    CURL_MAKE_CODE(CURLE_FTP_WEIRD_SERVER_REPLY),
    CURL_MAKE_CODE2(CURLE_REMOTE_ACCESS_DENIED,     "a service was denied by the server due to lack of access - when login fails this is not returned."),
    CURL_MAKE_CODE2(CURLE_FTP_ACCEPT_FAILED,        "[was obsoleted in April 2006 for 7.15.4, reused in Dec 2011 for 7.24.0]"),
    CURL_MAKE_CODE(CURLE_FTP_WEIRD_PASS_REPLY),
    CURL_MAKE_CODE2(CURLE_FTP_ACCEPT_TIMEOUT,       "timeout occurred accepting server [was obsoleted in August 2007 for 7.17.0, reused in Dec 2011 for 7.24.0]"),
    CURL_MAKE_CODE(CURLE_FTP_WEIRD_PASV_REPLY),
    CURL_MAKE_CODE(CURLE_FTP_WEIRD_227_FORMAT),
    CURL_MAKE_CODE(CURLE_FTP_CANT_GET_HOST),
    CURL_MAKE_CODE2(CURLE_HTTP2,                    "A problem in the http2 framing layer. [was obsoleted in August 2007 for 7.17.0, reused in July 2014 for 7.38.0]"),
    CURL_MAKE_CODE(CURLE_FTP_COULDNT_SET_TYPE),
    CURL_MAKE_CODE(CURLE_PARTIAL_FILE),
    CURL_MAKE_CODE(CURLE_FTP_COULDNT_RETR_FILE),
    CURL_MAKE_CODE2(CURLE_OBSOLETE20,               "NOT USED"),
    CURL_MAKE_CODE2(CURLE_QUOTE_ERROR,              "quote command failure"),
    CURL_MAKE_CODE(CURLE_HTTP_RETURNED_ERROR),
    CURL_MAKE_CODE(CURLE_WRITE_ERROR),
    CURL_MAKE_CODE2(CURLE_OBSOLETE24,               "NOT USED"),
    CURL_MAKE_CODE2(CURLE_UPLOAD_FAILED,            "failed upload \"command\""),
    CURL_MAKE_CODE2(CURLE_READ_ERROR,               "couldn't open/read from file"),
    CURL_MAKE_CODE2(CURLE_OUT_OF_MEMORY,            "Note: CURLE_OUT_OF_MEMORY may sometimes indicate a conversion error instead of a memory allocation error if CURL_DOES_CONVERSIONS is defined"),
    CURL_MAKE_CODE2(CURLE_OPERATION_TIMEDOUT,       "the timeout time was reached"),
    CURL_MAKE_CODE2(CURLE_OBSOLETE29,               "NOT USED"),
    CURL_MAKE_CODE2(CURLE_FTP_PORT_FAILED,          "FTP PORT operation failed"),
    CURL_MAKE_CODE2(CURLE_FTP_COULDNT_USE_REST,     "the REST command failed"),
    CURL_MAKE_CODE2(CURLE_OBSOLETE32,               "NOT USED"),
    CURL_MAKE_CODE2(CURLE_RANGE_ERROR,              "RANGE \"command\" didn't work"),
    CURL_MAKE_CODE(CURLE_HTTP_POST_ERROR),
    CURL_MAKE_CODE2(CURLE_SSL_CONNECT_ERROR,        "wrong when connecting with SSL"),
    CURL_MAKE_CODE2(CURLE_BAD_DOWNLOAD_RESUME,      "couldn't resume download"),
    CURL_MAKE_CODE(CURLE_FILE_COULDNT_READ_FILE),
    CURL_MAKE_CODE(CURLE_LDAP_CANNOT_BIND),
    CURL_MAKE_CODE(CURLE_LDAP_SEARCH_FAILED),
    CURL_MAKE_CODE2(CURLE_OBSOLETE40,               "NOT USED"),
    CURL_MAKE_CODE(CURLE_FUNCTION_NOT_FOUND),
    CURL_MAKE_CODE(CURLE_ABORTED_BY_CALLBACK),
    CURL_MAKE_CODE(CURLE_BAD_FUNCTION_ARGUMENT),
    CURL_MAKE_CODE2(CURLE_OBSOLETE44,               "NOT USED"),
    CURL_MAKE_CODE2(CURLE_INTERFACE_FAILED,         "CURLOPT_INTERFACE failed"),
    CURL_MAKE_CODE2(CURLE_OBSOLETE46,               "NOT USED"),
    CURL_MAKE_CODE2(CURLE_TOO_MANY_REDIRECTS ,      "catch endless re-direct loops"),
    CURL_MAKE_CODE2(CURLE_UNKNOWN_OPTION,           "User specified an unknown option"),
    CURL_MAKE_CODE2(CURLE_TELNET_OPTION_SYNTAX ,    "Malformed telnet option"),
    CURL_MAKE_CODE2(CURLE_OBSOLETE50,               "NOT USED"),
    CURL_MAKE_CODE2(CURLE_PEER_FAILED_VERIFICATION, "peer's certificate or fingerprint wasn't verified fine"),
    CURL_MAKE_CODE2(CURLE_GOT_NOTHING,              "when this is a specific error"),
    CURL_MAKE_CODE2(CURLE_SSL_ENGINE_NOTFOUND,      "SSL crypto engine not found"),
    CURL_MAKE_CODE2(CURLE_SSL_ENGINE_SETFAILED,     "can not set SSL crypto engine as default"),
    CURL_MAKE_CODE2(CURLE_SEND_ERROR,               "failed sending network data"),
    CURL_MAKE_CODE2(CURLE_RECV_ERROR,               "failure in receiving network data"),
    CURL_MAKE_CODE2(CURLE_OBSOLETE57,               "NOT IN USE"),
    CURL_MAKE_CODE2(CURLE_SSL_CERTPROBLEM,          "problem with the local certificate"),
    CURL_MAKE_CODE2(CURLE_SSL_CIPHER,               "couldn't use specified cipher"),
    CURL_MAKE_CODE2(CURLE_SSL_CACERT,               "problem with the CA cert (path?)"),
    CURL_MAKE_CODE2(CURLE_BAD_CONTENT_ENCODING,     "Unrecognized/bad encoding"),
    CURL_MAKE_CODE2(CURLE_LDAP_INVALID_URL,         "Invalid LDAP URL"),
    CURL_MAKE_CODE2(CURLE_FILESIZE_EXCEEDED,        "Maximum file size exceeded"),
    CURL_MAKE_CODE2(CURLE_USE_SSL_FAILED,           "Requested FTP SSL level failed"),
    CURL_MAKE_CODE2(CURLE_SEND_FAIL_REWIND,         "Sending the data requires a rewind that failed"),
    CURL_MAKE_CODE2(CURLE_SSL_ENGINE_INITFAILED,    "failed to initialise ENGINE"),
    CURL_MAKE_CODE2(CURLE_LOGIN_DENIED,             "user, password or similar was not accepted and we failed to login"),
    CURL_MAKE_CODE2(CURLE_TFTP_NOTFOUND,            "file not found on server"),
    CURL_MAKE_CODE2(CURLE_TFTP_PERM,                "permission problem on server"),
    CURL_MAKE_CODE2(CURLE_REMOTE_DISK_FULL,         "out of disk space on server"),
    CURL_MAKE_CODE2(CURLE_TFTP_ILLEGAL,             "Illegal TFTP operation"),
    CURL_MAKE_CODE2(CURLE_TFTP_UNKNOWNID,           "Unknown transfer ID"),
    CURL_MAKE_CODE2(CURLE_REMOTE_FILE_EXISTS,       "File already exists"),
    CURL_MAKE_CODE2(CURLE_TFTP_NOSUCHUSER,          "No such user"),
    CURL_MAKE_CODE2(CURLE_CONV_FAILED,              "conversion failed"),
    CURL_MAKE_CODE2(CURLE_CONV_REQD,                "caller must register conversion callbacks using curl_easy_setopt options CURLOPT_CONV_FROM_NETWORK_FUNCTION, CURLOPT_CONV_TO_NETWORK_FUNCTION, and CURLOPT_CONV_FROM_UTF8_FUNCTION"),
    CURL_MAKE_CODE2(CURLE_SSL_CACERT_BADFILE,       "could not load CACERT file, missing or wrong format"),
    CURL_MAKE_CODE2(CURLE_REMOTE_FILE_NOT_FOUND,    "remote file not found"),
    CURL_MAKE_CODE2(CURLE_SSH,                      "error from the SSH layer, somewhat generic so the error message will be of interest when this has happened"),
    CURL_MAKE_CODE2(CURLE_SSL_SHUTDOWN_FAILED,      "Failed to shut down the SSL connection"),
    CURL_MAKE_CODE2(CURLE_AGAIN,                    "socket is not ready for send/recv, wait till it's ready and try again (Added in 7.18.2)"),
    CURL_MAKE_CODE2(CURLE_SSL_CRL_BADFILE,          "could not load CRL file, missing or wrong format (Added in 7.19.0)"),
    CURL_MAKE_CODE2(CURLE_SSL_ISSUER_ERROR,         "Issuer check failed.  (Added in 7.19.0)"),
    CURL_MAKE_CODE2(CURLE_FTP_PRET_FAILED,          "a PRET command failed"),
    CURL_MAKE_CODE2(CURLE_RTSP_CSEQ_ERROR,          "mismatch of RTSP CSeq numbers"),
    CURL_MAKE_CODE2(CURLE_RTSP_SESSION_ERROR,       "mismatch of RTSP Session Ids"),
    CURL_MAKE_CODE2(CURLE_FTP_BAD_FILE_LIST,        "unable to parse FTP file list"),
    CURL_MAKE_CODE2(CURLE_CHUNK_FAILED,             "chunk callback reported error"),
    CURL_MAKE_CODE2(CURLE_NO_CONNECTION_AVAILABLE,  "No connection available, the session will be queued"),
    CURL_MAKE_CODE2(CURLE_SSL_PINNEDPUBKEYNOTMATCH, "specified pinned public key did not match"),
    CURL_MAKE_CODE2(CURLE_SSL_INVALIDCERTSTATUS,    "invalid certificate status"),
    CURL_MAKE_CODE2(CURL_LAST,                      "never use!")
};

NSString *CURLCodeToNSString(NSUInteger code) {
    if (code < CURL_LAST) {
        
        for (curlErrorCodes_s *record = curlCodes; record->code != CURL_LAST; record++) {
            
            if (record->code == code) {
                NSString *desc;
                
                if (record->extra) {
                    desc = [NSString stringWithFormat:@"%s: '%s'", record->description, record->extra];
                }
                else {
                    desc = [NSString stringWithFormat:@"%s", record->description];
                }
                
                return desc;
            }
        }
    }
    
    return @"CURLCodeToNSString: code out of bounds";
}

int CURLConnectionCurlDebugCallback(CURL *curl, curl_infotype infotype, char *info, size_t infoLen, void *contextInfo) {
    //CoreAssetWorker *assetWorker = (__bridge CoreAssetWorker *)contextInfo;
    NSData *infoData = [NSData dataWithBytes:info length:infoLen];
    NSString *infoStr = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
    
    if (infoStr) {
        infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];	// convert Windows CR/LF to just LF
        infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];	// convert remaining CRs to LFs
        
        switch (infotype) {
            case CURLINFO_DATA_IN:
                TestLog(@"CURL: %@", infoStr);
                break;
            case CURLINFO_DATA_OUT:
                TestLog(@"CURL: %@", [infoStr stringByAppendingString:@"\n"]);
                break;
            case CURLINFO_HEADER_IN:
                TestLog(@"CURL: %@", [@"< " stringByAppendingString:infoStr]);
                break;
            case CURLINFO_HEADER_OUT:
                infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\n> "];	// start each line with a /
                TestLog(@"CURL: %@", [NSString stringWithFormat:@"> %@\n", infoStr]);
                break;
            case CURLINFO_TEXT:
                TestLog(@"CURL: %@", [@"* " stringByAppendingString:infoStr]);
                break;
            default:	// ignore the other CURLINFOs
                break;
        }
    }
    
    return 0;
}

curlioerr CURLConnectionCurlIoctlCallback(CURL *handle, int cmd, void *clientp) {
    //CoreAssetWorker *assetWorker = (__bridge CoreAssetWorker *)clientp;
    
    if (cmd == CURLIOCMD_RESTARTREAD) {
        return CURLIOE_OK;
    }
    
    return CURLIOE_UNKNOWNCMD;
}

size_t CURLConnectionCurlReadCallback(void *ptr, size_t size, size_t nmemb, void *userdata) {
    const size_t sizeInBytes = size * nmemb;
    NSInputStream *input = (__bridge NSInputStream *)userdata;
    return [input read:ptr maxLength:sizeInBytes];
}

size_t CURLConnectionCurlWriteCallback(char *ptr, size_t size, size_t nmemb, void *userdata) {
    const size_t sizeInBytes = size * nmemb;
    NSMutableData *output = (__bridge NSMutableData *)userdata;
    [output appendBytes:ptr length:sizeInBytes];
    return sizeInBytes;
}

@implementation CURLConnection

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    // init
    NSMutableData *output = [NSMutableData new];
    CURL *curl = curl_easy_init();
    __block struct curl_slist *headers = NULL;
    
    // Some settings I recommend you always set:
    curl_easy_setopt(curl, CURLOPT_HTTPAUTH, CURLAUTH_ANY);	// support basic, digest, and NTLM authentication
    curl_easy_setopt(curl, CURLOPT_NOSIGNAL, 1L);	// try not to use signals
    curl_easy_setopt(curl, CURLOPT_USERAGENT, "FinTech-CURLConnection");	// set a default user agent
    
    // Things specific to this app:
    //curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);	// turn on verbose logging; your app doesn't need to do this except when debugging a connection
    curl_easy_setopt(curl, CURLOPT_DEBUGFUNCTION, CURLConnectionCurlDebugCallback);
    curl_easy_setopt(curl, CURLOPT_DEBUGDATA, self);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, CURLConnectionCurlWriteCallback);
    
    curl_easy_setopt(curl, CURLOPT_URL, request.URL.absoluteString.UTF8String);
    curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT_MS, (long)request.timeoutInterval * 1000);
    //curl_easy_setopt(curl, CURLOPT_TIMEOUT_MS, (long)request.timeoutInterval * 1000);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, output);	// prevent libcurl from writing the data to stdout
    curl_easy_setopt(curl, CURLOPT_LOW_SPEED_LIMIT, (long)5);
    curl_easy_setopt(curl, CURLOPT_LOW_SPEED_TIME, (long)request.timeoutInterval);
    
    NSDictionary *proxySettings = (__bridge_transfer NSDictionary *)CFNetworkCopySystemProxySettings();
    
    // Set up proxies:
    NSString *proxyHost;
    NSNumber *proxyPort;
    if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPEnable] && [[proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPEnable] boolValue]) {
        if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPProxy]) {
            proxyHost = [proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPProxy];
            curl_easy_setopt(curl, CURLOPT_PROXY, proxyHost.UTF8String);
        }
        
        if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPPort]) {
            proxyPort = [proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPPort];
            curl_easy_setopt(curl, CURLOPT_PROXYPORT, proxyPort.longValue);
        }
    }
    
    // setup header
    NSMutableArray *headerList = [[NSMutableArray alloc] initWithCapacity:request.allHTTPHeaderFields.count];
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *field = [NSString stringWithFormat:@"%@: %@", key, obj];
        [headerList addObject:field];
        headers = curl_slist_append(headers, field.UTF8String);
    }];
    
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    
//    NSInputStream *readData;
    if ([request.HTTPMethod isEqualToString:@"GET"]) {
        curl_easy_setopt(curl, CURLOPT_UPLOAD, 0L);
        curl_easy_setopt(curl, CURLOPT_HTTPGET, 1L);
    }
    else if ([request.HTTPMethod isEqualToString:@"POST"]) {
        curl_easy_setopt(curl, CURLOPT_UPLOAD, 0L);
        curl_easy_setopt(curl, CURLOPT_HTTPPOST, 1L);
        
        if (request.HTTPBody.length) {
//            readData = [[NSInputStream alloc] initWithData:request.HTTPBody];
            
            //curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);
            //curl_easy_setopt(curl, CURLOPT_READFUNCTION, CURLConnectionCurlReadCallback);
            //curl_easy_setopt(curl, CURLOPT_READDATA, readData);
            curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, request.HTTPBody.length);
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, request.HTTPBody.bytes);
        }
    }
    
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 2L);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1L);
    
    CURLcode theResult = curl_easy_perform(curl);
    
    if (theResult == CURLE_OK) {
        long http_code = 0;
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);
        
        NSHTTPURLResponse* httpResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:http_code HTTPVersion:@"1.1" headerFields:nil];
        if (response) {
            *response = httpResponse;
        }
    }
    
    curl_slist_free_all(headers);
    curl_easy_cleanup(curl);
    
    if (theResult != CURLE_OK) {
        //TestLog(@"CURLConnection: something wrong");
        
        if (error) {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"CURL: %@", CURLCodeToNSString(theResult)] code:theResult userInfo:nil];
        }
        
        return nil;
    }
    
    return output;
}

@end
