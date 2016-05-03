//
// Created by William Locke on 4/6/15.
// Copyright (c) 2016 Adtrade (http://adtrade.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ATHTTPRequest.h"
#import "ATDate.h"

@interface ATHTTPRequest(){
    NSOperationQueue *_queue;
	NSMutableURLRequest *_request;
}
@end

@implementation ATHTTPRequest

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:20];
        _request = [[NSMutableURLRequest alloc] init];
    }
    return self;
}

-(NSDictionary *)parseCacheControl:(NSString *)cacheControlString{
    NSMutableDictionary *cacheControl = [[NSMutableDictionary alloc] init];
    NSArray *fields = [cacheControlString componentsSeparatedByString:@","];
    NSString *field;
    for (field in fields) {
        NSArray *keyVal = [field componentsSeparatedByString:@"="];
        if ([keyVal count] == 2) {
            [cacheControl setObject:[keyVal objectAtIndex:1] forKey:[keyVal objectAtIndex:0]];
        }else{
            [cacheControl setObject:[NSNumber numberWithBool:YES] forKey:field];            
        }
    }
    return cacheControl;
}

-(NSDate *)expirationDateFromHttpResponse:(NSHTTPURLResponse *)urlResponse{
    NSString *expirationDateString = [[urlResponse allHeaderFields] objectForKey:@"Expires"];
    NSDate *expirationDate = nil;
    if (expirationDateString) {
        expirationDate = [ATDate dateFromString:expirationDateString];
    }else{
        NSString *dateString = [[urlResponse allHeaderFields] objectForKey:@"Date"];
        NSString *cacheControlString = [[urlResponse allHeaderFields] objectForKey:@"Cache-Control"];
        
        NSDate *date = [ATDate dateFromString:dateString];
        if (date && cacheControlString) {
            NSDictionary *cacheControl = [self parseCacheControl:cacheControlString];
            if (cacheControl && [cacheControl objectForKey:@"max-age"]) {
                int maxAge = [[cacheControl objectForKey:@"max-age"] intValue];
                expirationDate = [date dateByAddingTimeInterval:maxAge];
            }
        }
    }
    return expirationDate;
}

-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedURLResponse) {
        NSDate *expirationDate = [self expirationDateFromHttpResponse:(NSHTTPURLResponse *)[cachedURLResponse response]];
        if(expirationDate && ![ATDate isDatePast:expirationDate]){
            return cachedURLResponse;
        }else{
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        }
    }
    return nil;
}

-(NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            for (NSString *subKey in value) {
                NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                                (CFStringRef)[@"" stringByAppendingFormat:@"%@", [value objectForKey:subKey]],
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@%@%@%@=%@", key, @"%5B", subKey, @"%5D", escaped_value]];
            }
        } else if ([value isKindOfClass:[NSArray class]]) {
            for (NSString *subValue in value) {
                NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                              (CFStringRef)subValue,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@%@%@=%@", key, @"%5B", @"%5D", escaped_value]];
            }
        } else {
            NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                          (CFStringRef)[@"" stringByAppendingFormat:@"%@", [params objectForKey:key]],
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8));
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        }
    }
    return [pairs componentsJoinedByString:@"&"];
}


-(BOOL)sendRequestWithUrl:(NSString *)url
               httpMethod:(NSString *)httpMethod
                   withParams:(NSMutableDictionary *)params
                    files:(NSMutableArray *)files
        completionHandler:(completionHandler)completionHandler{
    return [self sendRequestWithUrl:url httpMethod:httpMethod withParams:params files:files httpAuthenticationKey:nil completionHandler:completionHandler];
}

-(BOOL)sendRequestWithUrl:(NSString *)url
               httpMethod:(NSString *)httpMethod
                   withParams:(NSDictionary *)params
                    files:(NSMutableArray *)files
    httpAuthenticationKey:(NSString *)httpAuthenticationKey
        completionHandler:(completionHandler)completionHandler{
    return [self sendRequestWithUrl:url httpMethod:httpMethod withParams:params files:files httpAuthenticationKey:httpAuthenticationKey headerFields:nil completionHandler:completionHandler];
}

-(BOOL)sendRequestWithUrl:(NSString *)url
               httpMethod:(NSString *)httpMethod
                   withParams:(NSDictionary *)params
                    files:(NSMutableArray *)files
                      httpAuthenticationKey:(NSString *)httpAuthenticationKey
                   headerFields:(NSMutableDictionary *)headerFields
        completionHandler:(completionHandler)completionHandler{
    
    
    _request = [[NSMutableURLRequest alloc] init];
    
    if(!params){
        params = [[NSMutableDictionary alloc] init];
    }else{
        params = [[NSMutableDictionary alloc] initWithDictionary:params];
    }
    if(!files){
        files = [[NSMutableArray alloc] init];
    }else{
        files = [[NSMutableArray alloc] initWithArray:files];
    }
    
    NSArray *methodsWithParametersPassedInBody = @[@"POST", @"PUT", @"PATCH", @"DELETE"];
    
    if ([methodsWithParametersPassedInBody indexOfObject:httpMethod] != NSNotFound) {
        [_request setURL:[NSURL URLWithString:url]];
        
        if(self.shouldPassHttpMethodAsParameter){
            [params setValue:[httpMethod lowercaseString] forKey:@"_method"];
        }
        [_request addValue:httpMethod forHTTPHeaderField: @"X-HTTP-Method-Override"];
        [_request setHTTPMethod:httpMethod];
        
        NSString *boundary = @"-----------------------------1137522503144128232716531729";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        if([headerFields objectForKey:@"Content-Type"]){
            contentType = [headerFields objectForKey:@"Content-Type"];
        }
        if([contentType isEqualToString:@"application/json"]){
            [_request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil];
            [_request setHTTPBody:jsonData];
        }else{
            [_request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];        
            for (NSString *key in params) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];					
                [body appendData:[[NSString stringWithString:[@""
                                                              stringByAppendingFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", 
                                                              key,[@"" stringByAppendingFormat:@"%@", [params objectForKey:key]]]] 
                                  dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            for (int i=0; i < [files count]; i++) {
                NSDictionary *file = [files objectAtIndex:i];
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithString:[@"" 
                                                              stringByAppendingFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [file objectForKey:@"name"], [file objectForKey:@"filename"]]] 
                                  dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" 
                                  dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[file objectForKey:@"data"]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }

            if ([files count] == 0) {
                [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];				
            }else{
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];				
            }

            [_request setHTTPBody:body];
            [_request addValue:[@"" stringByAppendingFormat:@"%lu", (unsigned long)[body length]]  forHTTPHeaderField: @"Content-Length"];
            [_request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField: @"Accept"];
        }
    }else{
        url = [url stringByAppendingString:@"?"];
        NSString *serializedParams = [self serializeParams:params];
        url = [url stringByAppendingFormat:@"%@", serializedParams];
        if([headerFields objectForKey:@"Content-Type"]){
            headerFields = [[NSMutableDictionary alloc] initWithDictionary:headerFields];            
            [headerFields removeObjectForKey:@"Content-Type"];
        }
        [_request setURL:[NSURL URLWithString:url]];
        [_request setHTTPMethod:@"GET"];
        [_request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        NSCachedURLResponse *cachedURLResponse;
        if ((cachedURLResponse = [self cachedResponseForRequest:_request])) {
            completionHandler([cachedURLResponse response], [cachedURLResponse data], nil);
            return YES;
        }
    }

    NSString *userAgent = [@"" stringByAppendingFormat:@"%@ %@ (%@; %@ %@; %@)",
                 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],
                 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                 [[UIDevice currentDevice] model],
                 [[UIDevice currentDevice] systemName],
                 [[UIDevice currentDevice] systemVersion],
                 [[NSLocale currentLocale] localeIdentifier]];
    [_request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    if(httpAuthenticationKey){
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", httpAuthenticationKey];
        [_request addValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    if(headerFields && ([headerFields isKindOfClass:[NSMutableDictionary class]] || [headerFields isKindOfClass:[NSDictionary class]])){
        for(NSString *key in headerFields){
            NSString *value = [headerFields valueForKey:key];
            [_request addValue:value forHTTPHeaderField:key];
        }
    }

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:_request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completionHandler(response, data, error);
    }];
    
    [dataTask resume];

    return YES;
}


@end
