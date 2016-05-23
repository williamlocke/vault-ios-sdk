//
//  ViewController.m
//  VaultSDK
//
//  Created by William Locke on 5/3/16.
//  Copyright © 2016 William Locke. All rights reserved.
//

#import "ViewController.h"
#import "VaultSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[VaultSDK sharedInstance] setEnvironment:VaultSDKEnvironmentSandbox];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)tokenizeButtonPressed:(id)sender{
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
}

-(void)showSuccess{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Successfully tokenized card"
                                          message:@"You've successfully tokenized this credit card with vault"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK action");
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showError{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error tokenizing card"
                                          message:@"Error tokenizing card"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK action");
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
