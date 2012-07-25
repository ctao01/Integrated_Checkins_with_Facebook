//
//  jAgendaViewController.m
//  jCalendarView
//
//  Created by Joy Tao on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jAgendaViewController.h"
#import "AppDelegate.h"

#import "NSDateFormatter+Extension.h"
#import "Reachability.h"

#import "jCustomizedCell.h"
#import "jSettingTableViewController.h"
#import "jMapViewController.h"

#import "jCheckinsViewController.h"
#import "jTableViewControllerViewController.h"

#define IPHONE_STATUS_BAR_HEIGHT 20
#define IPHONE_NAVIGATION_BAR_HEIGHT 44
#define IPHONE_TOOLBAR_HEIGHT 44 

@interface jAgendaViewController ()
{
    UIToolbar * toolBar;
    NSMutableDictionary * sortedDictionary;
    
    BOOL isConnected;
    
    CLLocationManager * locationManager;
    CLLocationDegrees  latitude;
    CLLocationDegrees  longitude;
}

@end

@implementation jAgendaViewController
@synthesize currentDate = _currentDate;
@synthesize checkinsArray;

#pragma mark - Setter/ Getter

- (void) setCurrentDate:(NSDate *)currentDate
{
    if (_currentDate == currentDate) return;
    [_currentDate release];
    _currentDate = [currentDate retain];
    
    NSLog(@"%@",_currentDate);
}

#pragma mark - Save / Load Data Method

- (void) saveDataToDiskWithArray:(NSMutableArray*)array
{
    AppDelegate * app_delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app_delegate saveDataToDisk:array];
}

- (NSMutableArray*) loadSavedDataFromDisk
{
    AppDelegate * app_delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray * array = [app_delegate loadDataFromDisk];
    return array;
}

- (NSMutableArray*) loadOfflineSavedDataFromDisk
{
    AppDelegate * app_delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray * array = [app_delegate loadOfflineDataFromDisk];
    return array;
}

#pragma mark - Helper

- (NSString*)tableView:(UITableView *)tableView keyStringForEachSection:(NSInteger)section
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSWeekOfMonthCalendarUnit fromDate:self.currentDate];
    
    [comps setYear:[comps year]];
    [comps setMonth:[comps month]];
    [comps setWeekOfMonth:[comps weekOfMonth]];
    [comps setWeekday:section+1];
    
    NSDate * aDate = [calendar dateFromComponents:comps];
    
    return [NSDateFormatter sectionHeaderStringFormDate:aDate];
}

- (NSInteger) tableView:(UITableView *)tableView dateForEachSection:(NSInteger)section
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSWeekOfMonthCalendarUnit fromDate:self.currentDate];
    
    [comps setYear:[comps year]];
    [comps setMonth:[comps month]];
    [comps setWeekOfMonth:[comps weekOfMonth]];
    [comps setWeekday:section+1];
    
    NSDate * aDate = [calendar dateFromComponents:comps];
    
    NSDateComponents * newComps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:aDate];
    NSInteger date = [newComps day];
    
    return date;
}

- (void) setNavigationItemTitle
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMMM,yyyy"];
    self.navigationItem.title = [formatter stringFromDate:self.currentDate];
}

#pragma mark - Data Method

- (NSMutableArray *) generatedTimestampArray:(NSMutableArray *)theArray
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int c = 0; c < [theArray count]; c++) {
        NSDate * timestamp = [NSDateFormatter dateFromISO8601String:[[theArray objectAtIndex:c] objectForKey:@"created_time"]];
        NSString * timeStr = [NSDateFormatter sectionHeaderStringFormDate:timestamp];    //yyyy-MM-dd;
        [array addObject:timeStr];
    }
    return array;
}

- (NSMutableArray *)cleanupDupliatedObject:(NSMutableArray *)array
{
    NSArray *copy = [array copy];
    NSInteger index = [copy count] - 1;
    for (id object in [copy reverseObjectEnumerator]) {
        if ([array indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [array removeObjectAtIndex:index];
        }
        index--;
    }
    [copy release];
    
    return array;
}

- (void) dataDictionaryFromUnsortedTimestampArray:(NSMutableArray *)array
{
    NSLog(@"theArray:%@",array);
    
    NSMutableArray * mutableArray = [self cleanupDupliatedObject:array];    // array = strings array
    sortedDictionary = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < [mutableArray count]; i++) 
    {
        NSMutableArray * array = [[NSMutableArray alloc]init];
        
        for (int j = 0; j < [self.checkinsArray count]; j++)
        {
            NSDate * date = [NSDateFormatter dateFromISO8601String:[[self.checkinsArray objectAtIndex:j] objectForKey:@"created_time"]];
            NSString * str = [NSDateFormatter sectionHeaderStringFormDate:date];
            
            if ([str isEqualToString:[mutableArray objectAtIndex:i]]) 
                [array addObject:[self.checkinsArray objectAtIndex:j]];
        }
        
        [sortedDictionary setObject:array forKey:[mutableArray objectAtIndex:i]];
    }    
    NSLog(@"sortedDictionary:%@",sortedDictionary);
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark -

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"Notification Says Reachable");
        isConnected = YES;
    }
    else
    {
        NSLog(@"Notification Says Unreachable");
        isConnected = NO;
    }
}

- (void) checkInsWithWifi:(BOOL)wifi
{
    jCheckinsViewController * vcCheckins = [[jCheckinsViewController alloc]init];
    [vcCheckins setCheckInsviaWifi:wifi];
    [vcCheckins setLatitude:latitude];
    [vcCheckins setLongitude:longitude];
    
     UINavigationController * nvCheckins = [[UINavigationController alloc]initWithRootViewController:vcCheckins];
    
    [self.navigationController presentModalViewController:nvCheckins animated:YES];
}

- (void) goToSetting
{
    jSettingTableViewController * tvSetting = [[jSettingTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController * nvSetting = [[UINavigationController alloc]initWithRootViewController:tvSetting];
    
    [self.navigationController presentModalViewController:nvSetting animated:YES];
}

- (void) add
{
    [locationManager stopUpdatingLocation];
    
    if (isConnected == YES)
    {
        UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"Check Ins" message:@"Check Ins Method" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Facebook", @"Manual", nil];
        [alertview show];
        [alertview release];
    }
    else
    {
        [self checkInsWithWifi:isConnected];
    }
}

#pragma mark - Core Location Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation");
    
    latitude = newLocation.coordinate.latitude;
    longitude = newLocation.coordinate.longitude;     
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    if (buttonIndex == 1) 
    {
        jTableViewControllerViewController * tvNearBy = [[jTableViewControllerViewController alloc]initWithStyle:UITableViewStylePlain withLatitude:latitude andLongitude:longitude];
        UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:tvNearBy];
        
        [self.navigationController presentModalViewController:navController animated:YES];
    }
    if (buttonIndex == 2)
    {
        [self checkInsWithWifi:isConnected];
    }
}


#pragma mark - Customized Cellview Action Method

- (void) tapTheView:(id)sender event:(id)event 
{
    UIGestureRecognizer * recongizer = (UIGestureRecognizer*)sender;
    int tappedViewTag = recongizer.view.tag;
    
    CGPoint currentTouchPosition = [recongizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    NSLog(@"row:%i,tag:%i",indexPath.section, tappedViewTag);
    
    jMapViewController * vcMap = [[jMapViewController alloc]init];
    NSString * key = [self tableView:self.tableView keyStringForEachSection:indexPath.section];
    [vcMap setTitle:key];
    
    
    NSArray * array = [sortedDictionary objectForKey:key];
    
    NSMutableArray * tempArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < [array count]; i++) 
    {
        NSNumber * latNum = [[[[array objectAtIndex:i] objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"latitude"];
        NSNumber * lngNum = [[[[array objectAtIndex:i] objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"longitude"];
        NSString * nameStr = [[[array objectAtIndex:i] objectForKey:@"place"] objectForKey:@"name"];
        
        NSString * timeStr = [[array objectAtIndex:i] objectForKey:@"created_time"];
        [tempArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              nameStr , @"name",
                              latNum , @"latitude",
                              lngNum , @"longitude",
                              [NSDateFormatter shortStyleStringFromDate:[NSDateFormatter dateFromISO8601String:timeStr]] , @"created_time",
                              nil]];
    }
    [vcMap setLocationArray:tempArray];
    NSLog(@"tempArray:%@",tempArray);
    [tempArray release];
    
    [self.navigationController pushViewController:vcMap animated:YES];
    [toolBar removeFromSuperview];
    
    [vcMap showMapCenterAtNumberOfIndex:tappedViewTag withLongitudeSpan:0.05 andLatitudeSpan:0.05];
//    [vcMap showMapCenterAtNumberOfIndex:0 withLongitudeSpan:0.05 andLatitudeSpan:0.05];
    
}

#pragma mark - Date Change Method

- (NSDate*)firstDayOfMonthWithDate:(NSDate*)date
{
    NSDateComponents * firstDateComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|  NSWeekOfMonthCalendarUnit|NSDayCalendarUnit  fromDate:date];
    [firstDateComps setYear:[firstDateComps year]];
    [firstDateComps setMonth:[firstDateComps month]];
    [firstDateComps setWeekOfMonth:1];
    [firstDateComps setDay:1];
    
    NSDate * firstDate = [[NSCalendar currentCalendar] dateFromComponents:firstDateComps];
    return firstDate;
}


- (void) nextMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
//    NSDateComponents * dateComps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSWeekOfMonthCalendarUnit fromDate:self.currentDate];
    [dateComps setMonth:1];
    NSDate *newDate  = [calendar dateByAddingComponents:dateComps toDate:self.currentDate options:0];
    NSLog(@"newDate:%@",newDate);
    NSDate * firstDate = [self firstDayOfMonthWithDate:newDate];
    
    [self setCurrentDate:firstDate];
    [self.tableView reloadData];
    
    [self setNavigationItemTitle];
}

- (void) nextWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    //    NSDateComponents * dateComps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSWeekOfMonthCalendarUnit fromDate:self.currentDate];
    [dateComps setWeek:1];

    NSDate *newDate  = [calendar dateByAddingComponents:dateComps toDate:self.currentDate options:0];
    
    [self setCurrentDate:newDate];
    [self.tableView reloadData];
    
    [self setNavigationItemTitle];
}

- (void) previousMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setMonth:-1];
    [dateComps setWeekOfMonth:1];

    NSDate *newDate  = [calendar dateByAddingComponents:dateComps toDate:self.currentDate options:0];
    
    NSDate * firstDate = [self firstDayOfMonthWithDate:newDate];
    
    [self setCurrentDate:firstDate];
    [self.tableView reloadData];
    
    [self setNavigationItemTitle];
    
}

- (void) previousWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setWeek:-1];
    NSDate *newDate  = [calendar dateByAddingComponents:dateComps toDate:self.currentDate options:0];
    
    [self setCurrentDate:newDate];
    [self.tableView reloadData];
    
    [self setNavigationItemTitle];

}

- (void) today
{
    [self setCurrentDate:[NSDate date]];
    [self.tableView reloadData];
    
    [self setNavigationItemTitle];

}

#pragma mark Facebook API Method

- (void)apiGraphUserCheckins 
{
    [[Facebook shared] requestWithGraphPath:@"me/checkins" andDelegate:self];
}

#pragma mark - Initializer

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycele

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentDate = [NSDate date];
    [self today];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UISwipeGestureRecognizer * swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextWeek)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tableView addGestureRecognizer:swipeLeftRecognizer];
    [swipeLeftRecognizer release];
    
    UISwipeGestureRecognizer * swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousWeek)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipeRightRecognizer];
    [swipeRightRecognizer release];
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    
    //Setup UIToolBar
    CGRect nvFrame = self.navigationController.view.frame;

    toolBar = [[UIToolbar alloc]init];    
    [toolBar setFrame:CGRectMake(0.0f, nvFrame.size.height - IPHONE_TOOLBAR_HEIGHT, 320, IPHONE_TOOLBAR_HEIGHT)];
    NSLog(@"%@",NSStringFromCGRect(toolBar.frame));
    UIBarButtonItem * nowItem = [[UIBarButtonItem alloc]initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(today)];

    UIBarButtonItem * previousItem = [[UIBarButtonItem alloc]initWithTitle:@"-" style:UIBarButtonItemStyleBordered target:self action:@selector(previousMonth)];
    UIBarButtonItem * nextItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleBordered target:self action:@selector(nextMonth)];
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * settingItem = [[UIBarButtonItem alloc]initWithTitle:@"Setting" style:UIBarButtonItemStyleBordered target:self action:@selector(goToSetting)];
    
    [toolBar setItems:[NSArray arrayWithObjects:previousItem,nowItem, nextItem,spaceItem,settingItem,nil]];
    [toolBar sizeToFit];
    [self.navigationController.view addSubview:toolBar];
    [toolBar release];
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, IPHONE_TOOLBAR_HEIGHT, 0.0f);
    self.tableView.contentInset = self.tableView.scrollIndicatorInsets;

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    

    // Setup Core Location Manager
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 50.0f;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    // Detect Internet Connection
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Reachable");
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"FB_USERNAME"]) {
                self.checkinsArray = [[NSMutableArray alloc]init];
                [self.checkinsArray addObjectsFromArray:[self loadOfflineSavedDataFromDisk]];
                [self performSelector:@selector(apiGraphUserCheckins)];
            }
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Unreachable");
            
            self.checkinsArray = [[NSMutableArray alloc]initWithArray:[self loadSavedDataFromDisk]];
            [self.checkinsArray addObjectsFromArray:[self loadOfflineSavedDataFromDisk]];
            [self.tableView reloadData];

        });
    };
    
    [reach startNotifier];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView");
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    jCustomizedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
            cell = [[jCustomizedCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

     if ([[NSDateFormatter sectionHeaderStringFormDate:[NSDate date]] isEqualToString:[self tableView:tableView keyStringForEachSection:indexPath.section]])
     {
         cell.weekdayLabel.textColor = [UIColor greenColor];
         cell.datelabel.textColor = [UIColor greenColor];
     }
    cell.tableViewController = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.datelabel.text = [NSString stringWithFormat:@"%i",[self tableView:tableView dateForEachSection:indexPath.section]];
    
    if (indexPath.section ==0)
    {
        cell.weekdayLabel.text = @"Sunday";
        cell.weekdayLabel.textColor = [UIColor redColor];
        cell.datelabel.textColor = [UIColor redColor];
    }
    
    if (indexPath.section ==1) cell.weekdayLabel.text = @"Monday";
    if (indexPath.section ==2) cell.weekdayLabel.text = @"Tuesday";
    if (indexPath.section ==3) cell.weekdayLabel.text = @"Wednesday";
    if (indexPath.section ==4) cell.weekdayLabel.text = @"Thursday";
    if (indexPath.section ==5) cell.weekdayLabel.text = @"Friday";
    if (indexPath.section ==6) 
    {
        cell.weekdayLabel.text = @"Saturday";
        cell.weekdayLabel.textColor = [UIColor blueColor];
        cell.datelabel.textColor = [UIColor blueColor];
    }
    
    NSString * key = [self tableView:tableView keyStringForEachSection:indexPath.section];
    cell.jArray = [sortedDictionary objectForKey:key];
    // Configure the cell...
   
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * key = [self tableView:tableView keyStringForEachSection:indexPath.section];
    NSArray * array = [sortedDictionary objectForKey:key];
    if ([array count] >1) {
        return [array count]*40 +([array count]+1)*5; 
    }

    return 50;
}

/*
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSWeekOfMonthCalendarUnit fromDate:self.currentDate];
    
    [comps setYear:[comps year]];
    [comps setMonth:[comps month]];
    [comps setWeekOfMonth:[comps weekOfMonth]];
    [comps setWeekday:section+1];
    
    NSDate * aDate = [calendar dateFromComponents:comps];
    
    return [NSDateFormatter sectionHeaderStringFormDate:aDate];

}*/

#pragma mark FBRequestDelegate Methods

- (void)requestLoading:(FBRequest *)request
{
    
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"received response!");
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Error message: %@", [error description]);
    if (error) 
        [self performSelector:@selector(apiGraphUserCheckins) withObject:nil afterDelay:1.0f];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    //    NSLog(@"result:%@",result);
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    
    if ([result objectForKey:@"data"])
    {        
        //        placesArray = [[NSMutableArray alloc]init];
        NSMutableArray * fbArray = [[NSMutableArray alloc]init];
        
        NSArray *resultData = [result objectForKey:@"data"];
        for (NSUInteger i=0; i<[resultData count]; i++) 
        {     
            NSArray * place = [[resultData objectAtIndex:i] objectForKey:@"place"];
            NSString *checkinMessage = [[resultData objectAtIndex:i] objectForKey:@"message"] ?
            [[resultData objectAtIndex:i] objectForKey:@"message"] : @"";
            NSString *createdTime = [[resultData objectAtIndex:i] objectForKey:@"created_time"];
            
            // Setup Time
            
            
            [fbArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                place,@"place",
                                createdTime, @"created_time",
                                checkinMessage,@"message",
                                nil]]; 
        }
        [self.checkinsArray addObjectsFromArray:fbArray];
        [self saveDataToDiskWithArray:self.checkinsArray];
        NSLog(@"self.checkinArray:%@",self.checkinsArray);

        
        NSMutableArray * temp = [self generatedTimestampArray:self.checkinsArray];
        [self performSelectorInBackground:@selector(dataDictionaryFromUnsortedTimestampArray:) withObject:temp];
    }
}
/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    
}

@end
