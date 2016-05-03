ATNetworking
============

Usage
-----

~~~
#import "ATNetworking.h"
~~~


Query an API. 
~~~

    [[ATNetworking sharedInstance] requestURL:@"https://www.googleapis.com/books/v1/volumes?q=harry+potter" completionHandler:^(NSDictionary *item, NSArray *items, NSError *error, NSDictionary *errorDictionary, NSURLResponse *response, NSDictionary *data) {
        
		if(!error){
			// Populates 'items' on API responses that contain list of objects.
			// Populates 'item' on API responses that contain a single object.
		
		}else{
			NSLog(@"An error occurr: %@", error.userInfo[NSLocalizedDescriptionKey]);

		}
		
    }];

~~~



### Testing

Open Project/ATNetworking.xcworkspace in Xcode and type Command-U


