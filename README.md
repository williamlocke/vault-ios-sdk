# Vault iOS SDK 

Objective-C SDK for consuming vault api. 

Usage
-----

```objective-c
#import "VaultSDK.h"
```

```objective-c

    NSDictionary *params = @{@"card_number":self.creditCardNumberTextField.text ? self.creditCardNumberTextField.text : @"4111111111111111",
                             @"expiration_month":self.expirationMonthTextField.text ? self.expirationMonthTextField.text :  @"12",
                             @"expiration_year":self.expirationYearTextField.text ? self.expirationYearTextField.text : @"2020",
                             @"security_code":self.securityCodeTextField.text ? self.securityCodeTextField.text : @"2020"
                             };
    [[VaultSDK sharedInstance] createTokenWithCard:params withSucess:^(NSDictionary * _Nonnull item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showSuccess];
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showError];
        });
    }];

```

Documentation
-------------

[Apple Docs](http://williamlocke.github.io/vault-ios-api/logs/appledoc/html/Classes/VaultSDK.html)
