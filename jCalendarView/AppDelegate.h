//
//  AppDelegate.h
//  jCalendarView
//
//  Created by Joy Tao on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook+Singleton.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic , retain) UINavigationController * navController;

- (NSMutableArray*) loadDataFromDisk;
- (NSMutableArray*) loadOfflineDataFromDisk;


- (void) saveOfflineDataToDisk:(NSMutableArray*)array;
- (void) saveDataToDisk:(NSMutableArray*)array;

@end
