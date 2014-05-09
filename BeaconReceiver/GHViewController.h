//
//  GHViewController.h
//  BeaconReceiver
//
//  Created by 昊川 on 4/9/14.
//  Copyright (c) 2014 Ghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RippleView.h"

@interface GHViewController : UIViewController<CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;

@end
