//
//  ATWebApiResponse.m
//  Pods
//
//  Created by William Locke on 3/21/15.
//
//

#import "ATWebApiResponse.h"

@implementation ATWebApiResponse

+(void)processResponse:(NSURLResponse *)response data:(NSData *)data withCompletionHandler:(void (^)(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSDictionary *data))completionHandler{

    NSDictionary *jsonObject = [ATWebApiResponse jsonObjectFromData:data];
    
    ATWebApiResponse *webApiResponse = [[ATWebApiResponse alloc] init];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    //NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    if([jsonObject isKindOfClass:[NSDictionary class]]){
        webApiResponse.data = jsonObject;
        
        if (jsonObject[@"count"] && ([jsonObject[@"count"] isKindOfClass:[NSNumber class]] || [jsonObject[@"count"] isKindOfClass:[NSString class]])) {
            webApiResponse.totalItems = [jsonObject[@"count"] intValue];
        }

        if((webApiResponse.errorDictionary = [jsonObject objectForKey:@"error"])){
            NSNumber *codeNumber;
            NSString *domain = @"";
            if([webApiResponse.errorDictionary isKindOfClass:[NSDictionary class]]){
                codeNumber = [webApiResponse.errorDictionary objectForKey:@"code"];
                if([webApiResponse.errorDictionary objectForKey:@"domain"]){
                    domain = [webApiResponse.errorDictionary objectForKey:@"domain"];
                }
            }
            int code = 0;
            if(codeNumber){
                code = [codeNumber intValue];
            }
            webApiResponse.error = [[NSError alloc] initWithDomain:domain code:code userInfo:webApiResponse.errorDictionary];
            webApiResponse.errorDictionary = webApiResponse.errorDictionary;

        }else if(httpResponse.statusCode >= 400) {
            webApiResponse.error = [[NSError alloc] initWithDomain:@"adtrade.com" code:httpResponse.statusCode userInfo:@{ NSLocalizedDescriptionKey:@"Unknown error"}];
        }else{
            NSDictionary *dataDictionary = jsonObject;
            if([jsonObject objectForKey:@"data"]){
                dataDictionary = [jsonObject objectForKey:@"data"];
            }
            
            if(dataDictionary[@"items"] && [dataDictionary[@"items"] isKindOfClass:[NSArray class]]){
                webApiResponse.items = dataDictionary[@"items"];
            }else if([dataDictionary isKindOfClass:[NSDictionary class]]){
                webApiResponse.item = dataDictionary;
            }else{
                webApiResponse.item = dataDictionary;
            }
            if (webApiResponse.items && [webApiResponse.items count] == 1) {
                webApiResponse.item = [webApiResponse.items firstObject];
            }
        }
    }else if([jsonObject isKindOfClass:[NSArray class]]){
        webApiResponse.items = (NSArray *)jsonObject;
    }else{
        webApiResponse.error = [[NSError alloc] initWithDomain:@"adtrade.com" code:422 userInfo:@{ NSLocalizedDescriptionKey: @"Unknown data type"}];
    }
    completionHandler(webApiResponse.item, webApiResponse.items, webApiResponse.error, webApiResponse.errorDictionary, webApiResponse.data);
}

+(id)jsonObjectFromData:(NSData *)data{
    if (!data) {
        return nil;
    }
    id object =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (object) {
        return object;
    }
    return nil;
}

@end
