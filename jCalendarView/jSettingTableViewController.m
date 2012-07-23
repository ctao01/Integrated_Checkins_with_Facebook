//
//  jSettingTableViewController.m
//  jCalendarView
//
//  Created by Joy Tao on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jSettingTableViewController.h"

@interface jSettingTableViewController ()

@end

@implementation jSettingTableViewController

#pragma mark Facebook API Method

- (void)apiGraphMe {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name,picture",  @"fields",
                                   nil];
    [[Facebook shared]requestWithGraphPath:@"me" andParams:params andDelegate:self];
    NSLog(@"apiGraphMe");
}

- (void) connectFB
{
    [[Facebook shared]authorize];
    
    [self apiGraphMe];
    
}

- (void) disconnectFB 
{
    [[Facebook shared]logout];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"FB_USERNAME"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self viewDidLoad];
}

#pragma mark - 

- (void) done
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - view lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apiGraphMe) name:@"FBDidLogin" object:nil];
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
    
    UIBarButtonItem * doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneItem;
    [doneItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FBDidLogin" object:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (indexPath.section ==0 )
    {
        cell.textLabel.text = @"Facebook";
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"FB_USERNAME"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"FB_USERNAME"] : @"NO CONFIG";
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) 
    {
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"FB_USERNAME"]) [self connectFB];
        else [self disconnectFB];
    }
}

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
        [self performSelector:@selector(apiGraphMe) withObject:nil afterDelay:1.0f];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    
    //    NSLog(@"result:%@",result);
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    
    if ([result isKindOfClass:[NSDictionary class]])
    {
        
        if ([result objectForKey:@"name"]) {
            NSString * fbUsername = [result objectForKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:fbUsername forKey:@"FB_USERNAME"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
            [self.tableView reloadData];
        }
    } 
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    
}

@end
