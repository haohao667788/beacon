//
//  SignInViewController.m
//  BeaconReceiver
//
//  Created by 昊川 on 4/13/14.
//  Copyright (c) 2014 Ghao. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.phone = self.phoneNumber.text;
    
    [self.phoneNumber resignFirstResponder];
    
    return YES;
}

#pragma mark - Navigation

- (IBAction)signIn:(id)sender {
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString *deviceId = [self.phone stringByAppendingString:[NSString stringWithFormat:@"%f", now]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.phone forKey:@"phone"];
    [defaults setObject:deviceId forKey:@"deviceId"];
    [defaults synchronize];
    
    NSLog(@"Success");
}

@end
