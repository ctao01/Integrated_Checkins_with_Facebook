//
//  jMapViewController.h
//  jCheckInsMap
//
//  Created by Joy Tao on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface jMapViewController : UIViewController < MKMapViewDelegate >
{
    NSMutableArray * _locationArray;
}
@property (nonatomic , retain) NSMutableArray * locationArray;

- (void) showMapCenterAtNumberOfIndex:(NSInteger)index withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX;

@end
