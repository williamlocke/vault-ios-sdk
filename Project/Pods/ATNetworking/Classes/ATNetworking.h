//
//  ATNetworking.h
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

#import <UIKit/UIKit.h>
#import "ATWebApiResponse.h"

@class ATHTTPRequest;

@interface ATNetworking : NSObject

@property (nonatomic, copy) NSString *baseUrl;
@property (strong, nonatomic) ATHTTPRequest *httpRequest;
@property (strong, nonatomic) NSString *httpAuthenticationKey;
@property (strong, nonatomic) NSDictionary *headerFields;
@property (strong, nonatomic) NSString *serializationFormat;
@property Class webApiResponseClass;

@property (strong, nonatomic) NSMutableArray *httpRequests;

+(ATNetworking *)sharedInstance;

typedef void (^ ATWebApiResponseHandler)(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data);


-(void)requestURL:(NSString *)url
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
       httpMethod:(NSString *)httpMethod
          headers:(NSDictionary *)headers
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
           withParams:(NSDictionary *)params
            files:(NSMutableArray *)files
       httpMethod:(NSString *)httpMethod
          options:(NSDictionary *)options
completionHandler:(ATWebApiResponseHandler)completionHandler;

-(void)requestURL:(NSString *)url
           withParams:(NSDictionary *)params
            files:(NSMutableArray *)files
       httpMethod:(NSString *)httpMethod
     headerFields:(NSDictionary *)headerFields
          options:(NSDictionary *)options
completionHandler:(ATWebApiResponseHandler)completionHandler;


- (id)initWithBaseUrl:(NSString *)baseUrl;


@end
