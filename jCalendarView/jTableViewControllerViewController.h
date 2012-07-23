//
//  jTableViewControllerViewController.h
//  jCalendarFrame
//
//  Created by Joy Tao on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook+Singleton.h"

@interface jTableViewControllerViewController : UITableViewController <FBRequestDelegate>
{
    NSArray * _placesArray;
}

@property (nonatomic, retain) NSNumber* latitudeNum;
@property (nonatomic, retain) NSNumber* longitudeNum;

@property (nonatomic , retain) NSArray * placesArray;

- (id) initWithStyle:(UITableViewStyle)style withLatitude:(double)latitude andLongitude:(double)longitude;
- (void) apiSearchNearByPlace;


@end
