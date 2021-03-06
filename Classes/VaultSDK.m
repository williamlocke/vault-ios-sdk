//
// Created by William Locke on 5/3/16.
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

#import "VaultSDK.h"
#import "ATNetworking.h"

@interface VaultSDK(){
    NSString *_publishableKey;
}

@end

@implementation VaultSDK

+(VaultSDK *)sharedInstance{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init{
    self = [super init];
    if (self) {
        [[ATNetworking sharedInstance] setBaseUrl:@"https://api.verygoodvault.com"];
    }
    return self;
}

-(void)setEnvironment:(VaultSDKEnvironment)environment{
    switch (environment) {
        case VaultSDKEnvironmentSandbox:
            [[ATNetworking sharedInstance] setBaseUrl:@"https://sandbox.verygoodvault.com"];
            break;
        default:
            [[ATNetworking sharedInstance] setBaseUrl:@"https://api.verygoodvault.com"];
            break;
    }
}

-(void)setServer:(NSString *)serverURL{
    [[ATNetworking sharedInstance] setBaseUrl:serverURL];
}

#pragma mark ATNetworking
-(void)requestURL:(NSString *)url
       withParams:(NSDictionary *)params
       httpMethod:(NSString *)httpMethod
          headers:(NSMutableDictionary *)headers
completionHandler:(ATWebApiResponseHandler)completionHandler{
    if(!params){
        params = [NSMutableDictionary new];
    }
    if(!headers){
        headers = [NSMutableDictionary new];
    }
    [headers addEntriesFromDictionary:[self defaultHeaders]];
    
    [[ATNetworking sharedInstance] requestURL:url withParams:params httpMethod:httpMethod headers:headers completionHandler:completionHandler];
}

#pragma mark Tokens
-(void)createTokenWithCreditCardNumber:(NSDictionary *)params withSucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure{
    [self requestURL:@"/tokens" withParams:params httpMethod:@"POST" headers:nil completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        if (item) {
            success(item);
        }else{
            failure(error);
        }
    }];
}

#pragma mark Default parameters
-(NSMutableDictionary *)defaultHeaders{
    NSMutableDictionary *headers =  [[NSMutableDictionary alloc] initWithDictionary:@{}];
    // NB: vault adopts using publishing token (e.g. vault_live_AbCdEfG..) of sorts as a username with
    // empty string password sent via HTTP Basic Authentication.
    NSString *username = _publishableKey;
    NSString *password = @"";
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64Encoding];
    [headers setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forKey:@"Authorization"];
    [headers setValue:@"application/json" forKey:@"Content-Type"];
    return headers;
}

-(void)setPublishableKey:(NSString *)publishableKey{
    _publishableKey = publishableKey;
}

@end

