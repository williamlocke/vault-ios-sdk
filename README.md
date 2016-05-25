# Vault iOS SDK 

Objective-C SDK for consuming vault api. 

Usage
-----

```objective-c
#import "VaultSDK.h"
```

#### configure

```objective-c
[[VaultSDK sharedInstance] setPublishableKey:@"vault_live_AbCdEfGhIjKLMnOpqrS"];
```

#### Create token

```objective-c

    NSDictionary *params = @{@"raw": ![self.creditCardNumberTextField.text isEqualToString:@""] ? self.creditCardNumberTextField.text : @"4111111111111111" };
    
    [[VaultSDK sharedInstance] createTokenWithCreditCardNumber:params withSucess:^(NSDictionary * _Nonnull item) {
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

[Apple Docs](http://williamlocke.github.io/vault-ios-sdk/logs/appledoc/html/Classes/VaultSDK.html)
