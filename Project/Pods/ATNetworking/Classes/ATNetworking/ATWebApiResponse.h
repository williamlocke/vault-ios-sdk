//
//  ATWebApiResponse.h
//  Pods
//
//  Created by William Locke on 3/21/15.
//
//

#import <UIKit/UIKit.h>

@interface ATWebApiResponse : NSObject

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSDictionary *errorDictionary;
@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, strong) NSArray *items;

@property long int totalItems;
@property (nonatomic, copy) NSString *nextLink;
@property (nonatomic, copy) NSString *previousLink;
@property (nonatomic, copy) NSDictionary *data;

// Possibly remove
@property (nonatomic, strong) NSURLResponse *response;

@property Class webApiResponseDataClass;

+(void)processResponse:(NSURLResponse *)response data:(NSData *)data withCompletionHandler:(void (^)(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSDictionary *data))completionHandler;

@end
