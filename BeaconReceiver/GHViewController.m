//
//  GHViewController.m
//  BeaconReceiver
//
//  Created by 昊川 on 4/9/14.
//  Copyright (c) 2014 Ghao. All rights reserved.
//

#import "GHViewController.h"

@interface GHViewController ()

@property (nonatomic, strong) UILocalNotification *notification;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) RippleView *rippleView;

@end

@implementation GHViewController

- (UILocalNotification *)notification
{
    if (!_notification) {
        _notification = [[UILocalNotification alloc] init];
        _notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        _notification.timeZone = [NSTimeZone defaultTimeZone];
    }
    return _notification;
}

- (UIAlertView *)alert
{
    if (!_alert) {
        _alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                            message:@""
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    }
    return _alert;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.gh"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0]];
    self.rippleView = [[RippleView alloc] initWithFrame:CGRectMake(0, height-width-50, width, width)];
    [self.view addSubview:self.rippleView];
    [self.rippleView start];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    self.statusLabel.text = @"匹配中……";
    self.uuidLabel.text = @"";
    
    // notification
    self.notification.alertBody = @"已进入Beacon服务器范围";
    [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
    
    [self.rippleView stop];
    [self sendRequest];
}

- (void)sendRequest
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phone = [defaults objectForKey:@"phone"];
    NSString *deviceId = [defaults objectForKey:@"deviceId"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://10.74.41.181:3000/pi/sign?number=%@&deviceId=%@", phone, deviceId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ([data length] > 0 && error == nil) {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([dict[@"success"] integerValue] == 0) {
                [self.alert setMessage:dict[@"message"]];
                [self.alert show];
            } else {
                [self.alert setMessage:@"签到成功!"];
                [self.alert show];
            }
        } else if (error != nil) {
            [self.alert setMessage:@"网络请求失败!"];
            [self.alert show];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    self.statusLabel.text = @"搜索中……";
    self.uuidLabel.text = @"";
    
    // notification
    self.notification.alertBody = @"已脱离Beacon服务器范围";
    [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
    
    [self.rippleView stop];
    [self.rippleView start];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside) {
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    } else if (state == CLRegionStateOutside) {
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CLBeacon *foundBeacon = [beacons firstObject];
    NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    
    self.statusLabel.text = @"已匹配到Beacon服务器";
    self.uuidLabel.text = uuid;
    
    [self.locationManager requestStateForRegion:self.beaconRegion];
}

#pragma mark - statusBar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
