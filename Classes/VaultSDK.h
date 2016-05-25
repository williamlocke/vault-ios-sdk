//
//  VaultSDK.h
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

#import <UIKit/UIKit.h>
@class ATHTTPRequest;

typedef enum : NSUInteger {
    VaultSDKEnvironmentSandbox,
    VaultSDKEnvironmentLive,
} VaultSDKEnvironment;

@interface VaultSDK : NSObject

+(nonnull VaultSDK *)sharedInstance;

-(void)setServer:(nonnull NSString *)serverURL;
-(void)setEnvironment:(VaultSDKEnvironment)environment;

-(void)setPublishableKey:(NSString *)publishableKey;


///---------------------------------------------------------------------------------------
/// @name Tokens
///---------------------------------------------------------------------------------------
/** Create token for credit card
 
 @param creditCard A dictionary representing a credit card. Must include 'raw':'4242424242424242'
 @param success Block passes back dictionary object representing a token. See SDK docs for dictionary structure.
 @param failure Block passes back `NSError` object describing error that occurred. See userInfo[NSLocalizedDescriptionKey] for description of error.
 */
-(void)createTokenWithCreditCardNumber:(nonnull NSDictionary *)creditCard withSucess:(nullable void (^ )(NSDictionary *_Nonnull item))success failure:(nullable void (^ )(NSError *_Nonnull error))failure;


@end
