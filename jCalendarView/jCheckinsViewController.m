//
//  jCheckinsViewController.m
//  jCalendarView
//
//  Created by Joy Tao on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jCheckinsViewController.h"
#import "AppDelegate.h"

#import "NSDateFormatter+Extension.h"
#import "Annotation.h"

@interface jCheckinsViewController ()
{
    MKMapView * mapView; 
    
    NSMutableArray * savedArray; 
    
    NSMutableDictionary * newCheckinsPlace;
}
@end

@implementation jCheckinsViewController
@synthesize checkInsviaWifi;
@synthesize latitude, longitude;

#pragma mark Facebook API Method

- (void)apiUpdateStatus
{
    
    NSMutableDictionary *params = [NSMutableDictionary  dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%@ - at %@",[newCheckinsPlace objectForKey:@"place_message"], [newCheckinsPlace objectForKey:@"place_name"]], @"message",
                                   nil];
    [[Facebook shared] requestWithGraphPath:@"me/feed"
                          andParams:params
                      andHttpMethod:@"POST"
                        andDelegate:self];
}

- (void) done
{
    if (checkInsviaWifi == YES)
    {
        [self apiUpdateStatus];
    }
    else 
    {
        AppDelegate * app_delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        savedArray = [[NSMutableArray alloc]initWithArray:[app_delegate loadOfflineDataFromDisk]];
        
        NSMutableDictionary * location = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%f",latitude],@"latitude",
                                          [NSString stringWithFormat:@"%f",longitude],@"longitude",
                                          nil];
        NSMutableDictionary * place = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                       location, @"location",
                                       [newCheckinsPlace objectForKey:@"place_name"], @"name",
                                       nil];
        
        [savedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               place , @"place",
                               [NSDateFormatter stringFromISO8601Date:[NSDate date]], @"created_time",
                               [newCheckinsPlace objectForKey:@"place_message"],@"message", 
                               nil]];
        
        [app_delegate saveOfflineDataToDisk:savedArray];
    }
    
}

- (void) cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) setupMapView
{
    CLLocationCoordinate2D pinCenter;
    pinCenter.latitude = latitude;
    pinCenter.longitude = longitude;
    
    Annotation * annotation = [[Annotation alloc]initWithCoordinate:pinCenter];
    annotation.title = [NSString stringWithFormat:@"%f,%f",latitude,longitude];
    annotation.subtitle = [NSDateFormatter shortStyleStringFromDate:[NSDate date]];
    
    [mapView addAnnotation:annotation];
    [annotation release];
}

#pragma mark - view lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITextField * nameField  = [[UITextField alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 24.0f)];
        nameField.frame = CGRectOffset(nameField.frame, 20.0f, 40.0f);
        nameField.layer.borderWidth = 1.0f;
        nameField.layer.borderColor = [[UIColor grayColor]CGColor];
        nameField.delegate = self;
        
        UITextView * messageField = [[UITextView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 80.0f)];
        messageField.frame = CGRectOffset(messageField.frame, 20.0f,84.0f);
        messageField.backgroundColor = [UIColor whiteColor];
        messageField.layer.borderWidth = 2.0f;
        messageField.layer.borderColor = [[UIColor grayColor]CGColor];
        messageField.delegate = self;

        mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 280.0f)];
        mapView.frame = CGRectOffset(mapView.frame, 20.0f, 184.0f);
        
        
        [self.view addSubview:nameField];
        [self.view addSubview:messageField];
        [self.view addSubview:mapView];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Check Ins";
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIBarButtonItem * doneItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [cancelItem release];
    [doneItem release];
    
    newCheckinsPlace = [[NSMutableDictionary alloc]init];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppearlatitude:%f",latitude);
    mapView.mapType = MKMapTypeStandard;
    mapView.userInteractionEnabled = YES;
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } }; 
    region.center.latitude = latitude;
    region.center.longitude = longitude;
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01;
    [mapView setRegion:region animated:YES];
    
    [self setupMapView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{           
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    [newCheckinsPlace setObject:textField.text forKey:@"place_name"];
    NSLog(@"newCheckinsPlace%@",newCheckinsPlace);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [newCheckinsPlace setObject:textView.text forKey:@"place_message"];
    NSLog(@"newCheckinsPlace%@",newCheckinsPlace);

}

#pragma mark - MKMapDelegate Method

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) 
    {
        return nil;
    }    
    MKPinAnnotationView * annotationView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil]autorelease];
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES; 
    
    return annotationView;
    
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
        [self performSelector:@selector(apiUpdateStatus) withObject:nil afterDelay:1.0f];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    if (result)
    {
        NSLog(@"successful!");
        AppDelegate * app_delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        savedArray = [[NSMutableArray alloc]initWithArray:[app_delegate loadOfflineDataFromDisk]];
        
        NSMutableDictionary * location = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%f",latitude],@"latitude",
                                          [NSString stringWithFormat:@"%f",longitude],@"longitude",
                                          nil];
        NSMutableDictionary * place = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                       location, @"location",
                                       [newCheckinsPlace objectForKey:@"place_name"], @"name",
                                       nil];
        
        [savedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               place , @"place",
                               [NSDateFormatter stringFromISO8601Date:[NSDate date]], @"created_time",
                               [newCheckinsPlace objectForKey:@"place_message"],@"message", 
                               nil]];
        
        [app_delegate saveOfflineDataToDisk:savedArray];
        
        [self dismissModalViewControllerAnimated:YES];
        
    }
}
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    
}

@end
