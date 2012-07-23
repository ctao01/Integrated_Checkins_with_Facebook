//
//  jTableViewControllerViewController.m
//  jCalendarFrame
//
//  Created by Joy Tao on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jTableViewControllerViewController.h"
@interface jTableViewControllerViewController ()

@end

@implementation jTableViewControllerViewController
@synthesize latitudeNum, longitudeNum;
@synthesize placesArray = _placeArray;
#pragma mark Facebook API Method

- (void)apiSearchNearByPlace
{
    NSString * coordinateString = [NSString stringWithFormat: @"%f,%f", 
                              [latitudeNum doubleValue], 
                              [longitudeNum doubleValue]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"place",@"type",
                                   coordinateString,@"center",
                                   @"1000",@"distance", // In Meters (1000m = 0.62mi)
                                   nil];
    
    [[Facebook shared] requestWithGraphPath:@"search" andParams:params andDelegate:self];
    NSLog(@"apiGraphUserCheckins");
}

- (void) apiPublishCheckins:(NSMutableDictionary*)dict
{
    [[Facebook shared]requestWithGraphPath:@"me/checkins" andParams:dict andHttpMethod:@"POST" andDelegate:self];
}

#pragma mark - Setter and Getter

- (void) setPlacesArray:(NSArray *)placesArray
{
//    if (_placesArray == placesArray) return;
    [_placesArray release];
    _placesArray = [placesArray retain];
    
    NSLog(@"Place:%@",_placesArray);
    [self.tableView reloadData];
    
}

#pragma mark-

- (void) back
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithStyle:(UITableViewStyle)style withLatitude:(double)latitude andLongitude:(double)longitude
{
    self = [self initWithStyle:style];
    if (self) {
        latitudeNum = [NSNumber numberWithDouble:latitude];
        longitudeNum = [NSNumber numberWithDouble:longitude];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Near By";
    UIBarButtonItem * backItem  = [[UIBarButtonItem alloc]initWithTitle:@"Cacnel" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    NSLog(@"%@,%@",latitudeNum, longitudeNum);
    [self apiSearchNearByPlace];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_placesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    cell.textLabel.text = [[_placesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    // Configure the cell...
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",indexPath.row];
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
    NSDictionary * placeDict = [_placesArray objectAtIndex:indexPath.row];
    
    SBJSON *jsonWriter = [[SBJSON new] autorelease];

    NSDictionary * coordinatesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [[placeDict objectForKey:@"location"] objectForKey:@"latitude"], @"latitude",
                                             [[placeDict objectForKey:@"location"] objectForKey:@"longitude"], @"longitude",nil];
    NSString *coordinatesStr = [jsonWriter stringWithObject:coordinatesDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [placeDict objectForKey:@"id"], @"place", //The PlaceID
                                   coordinatesStr, @"coordinates",
                                   @"", @"message",
                                   @"",@"tags",nil];
    
    NSLog(@"parms:%@",params);
//    [self apiPublishCheckins:params];
    [[Facebook shared]requestWithGraphPath:@"me/checkins" andParams:params andHttpMethod:@"POST" andDelegate:self];

    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark FBRequestDelegate Methods

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request
{
    
}
/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"received response!");
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Error message: %@", [error description]);
    if (error) 
        [self performSelector:@selector(apiSearchNearByPlace) withObject:nil afterDelay:1.0f];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    
    //    NSLog(@"result:%@",result);
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    if ([result objectForKey:@"data"])
    {
//        [self setPlacesArray:[result objectForKey:@"data"]];
        self.placesArray = [result objectForKey:@"data"];

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
