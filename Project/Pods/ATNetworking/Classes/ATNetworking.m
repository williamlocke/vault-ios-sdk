//
// Created by William Locke on 4/9/15.
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

#import "ATNetworking.h"
#import "ATHTTPRequest.h"

static ATNetworking *_sharedWebApi;

@implementation ATNetworking

+ (ATNetworking *)sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init{
    self = [self initWithBaseUrl:@""];
    if (self) {
        
    }
    return self;
}

- (id)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
        _webApiResponseClass = [ATWebApiResponse class];
        
        _baseUrl = baseUrl;
        _httpRequest = [[ATHTTPRequest alloc] init];
        if(!_serializationFormat){
            _serializationFormat = @"";
        }
    }
    return self;
}


-(void)requestURL:(NSString *)url
completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:nil files:nil httpMethod:@"GET" headerFields:nil options:nil completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:params files:nil httpMethod:@"GET" headerFields:nil options:nil completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
       httpMethod:(NSString *)httpMethod
          headers:(NSMutableDictionary *)headers
completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:params files:nil httpMethod:httpMethod headerFields:headers options:nil completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
           withParams:(NSDictionary *)params
       httpMethod:(NSString *)httpMethod
          options:(NSMutableDictionary *)options completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:params files:nil httpMethod:httpMethod options:options completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
           withParams:(NSDictionary *)params
            files:(NSMutableArray *)files
       httpMethod:(NSString *)httpMethod
          options:(NSMutableDictionary *)options completionHandler:(ATWebApiResponseHandler)completionHandler{
    [self requestURL:url withParams:params files:nil httpMethod:httpMethod headerFields:nil options:options completionHandler:completionHandler];
}

-(void)requestURL:(NSString *)url
           withParams:(NSDictionary *)params
            files:(NSMutableArray *)files    
       httpMethod:(NSString *)httpMethod
       headerFields:(NSMutableDictionary *)headerFields
          options:(NSMutableDictionary *)options completionHandler:(ATWebApiResponseHandler)completionHandler{
    if(_baseUrl && [url rangeOfString:@"http"].location != 0){
        url = [_baseUrl stringByAppendingFormat:@"%@%@", url, self.serializationFormat];
    }
    
    ATHTTPRequest *httpRequest = [[ATHTTPRequest alloc] init];
    if (!_httpRequests) {
        _httpRequests = [[NSMutableArray alloc] init];
    }
    [_httpRequests addObject:httpRequest];
    
    [httpRequest sendRequestWithUrl:url
                         httpMethod:httpMethod
                             withParams:params
                              files:files
              httpAuthenticationKey:_httpAuthenticationKey
              headerFields:headerFields
                  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                      
                      
                      [ATWebApiResponse processResponse:response data:data withCompletionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSDictionary *data) {
                          
                          
                          completionHandler(item, items, error, errorDictionary, response, data);
                      }];
                      
                      [_httpRequests removeObject:httpRequest];
                  }];
}

@end
