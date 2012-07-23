//
//  AppDelegate.m
//  jCalendarView
//
//  Created by Joy Tao on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "jAgendaViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

#pragma mark - Check for networking connection

- (void) saveDataToDisk:(NSMutableArray*)array
{
    NSData * myObject = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:myObject forKey:@"user_saved_data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) saveOfflineDataToDisk:(NSMutableArray*)array
{
    NSData * myObject = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:myObject forKey:@"user_pendding_data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray*) loadDataFromDisk
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    NSData * myDecodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_saved_data"];
    NSMutableArray * decodedArray = [NSKeyedUnarchiver unarchiveObjectWithData:myDecodedObject];
    if (decodedArray != nil) {
        NSLog(@"file exists :) Read data successfully");
        array = decodedArray;
        return array;
    }
    else {
        NSLog(@"file exists, but can't read data");
        array = [[NSMutableArray alloc]init];
        return array;
    }
}

- (NSMutableArray*) loadOfflineDataFromDisk
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    NSData * myDecodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_pendding_data"];
    NSMutableArray * decodedArray = [NSKeyedUnarchiver unarchiveObjectWithData:myDecodedObject];
    if (decodedArray != nil) 
    {
        NSLog(@"file exists :) Read data successfully");
        array = decodedArray;
        return array;
    }
    else
    {
        array = [[NSMutableArray alloc]init];
        return array;
    }
}


- (void)dealloc
{
    [_window release];
    [_navController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    jAgendaViewController * agendaView = [[jAgendaViewController alloc]initWithStyle:UITableViewStylePlain];
    self.navController = [[UINavigationController alloc]initWithRootViewController:agendaView];
    [self.window addSubview:self.navController.view];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[Facebook shared]extendAccessTokenIfNeeded];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[Facebook shared] handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[Facebook shared] handleOpenURL:url];
}

@end
