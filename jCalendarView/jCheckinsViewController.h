//
//  jCheckinsViewController.h
//  jCalendarView
//
//  Created by Joy Tao on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

#import "Facebook+Singleton.h"

@interface jCheckinsViewController : UIViewController < FBRequestDelegate , UITextFieldDelegate , UITextViewDelegate , MKMapViewDelegate>


@property (nonatomic , assign) BOOL checkInsviaWifi;
@property (nonatomic , assign) CLLocationDegrees  latitude;
@property (nonatomic , assign) CLLocationDegrees  longitude;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude andCheckWifi:(BOOL)wifi;


@end
