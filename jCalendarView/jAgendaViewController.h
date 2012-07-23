//
//  jAgendaViewController.h
//  jCalendarView
//
//  Created by Joy Tao on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

#import "Facebook+Singleton.h"

@interface jAgendaViewController : UITableViewController <FBRequestDelegate ,UIAlertViewDelegate, CLLocationManagerDelegate>
{
    NSDate * _currentDate;
}

@property (nonatomic , retain) NSDate * currentDate;
@property (nonatomic , retain) NSMutableArray * checkinsArray;


@end
