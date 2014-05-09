//
//  SignInViewController.h
//  BeaconReceiver
//
//  Created by 昊川 on 4/13/14.
//  Copyright (c) 2014 Ghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) NSString *phone;

- (IBAction)signIn:(id)sender;

@end
