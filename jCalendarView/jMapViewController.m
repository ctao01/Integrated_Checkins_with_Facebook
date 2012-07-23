//
//  jMapViewController.m
//  jCheckInsMap
//
//  Created by Joy Tao on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jMapViewController.h"
#import "Annotation.h"

@interface jMapViewController ()
{
    MKMapView * jMapView;
}

@end

@implementation jMapViewController
@synthesize locationArray = _locationArray;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.locationArray = [[NSMutableArray alloc]init];
    
    }
    return self;
}

#pragma mark - Setter

- (void) setLocationArray:(NSMutableArray *)locationArray
{
    if (_locationArray == locationArray) return;
    [_locationArray release];
    _locationArray = [locationArray retain];
  
}

#pragma mark - 

- (void) showMapCenterAtNumberOfIndex:(NSInteger)index withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX
{
    NSLog(@"showMapCenterAtNumberOfIndex");
    CLLocationCoordinate2D pinCenter;
    pinCenter.latitude = [[[self.locationArray objectAtIndex:index] objectForKey:@"latitude"] doubleValue];
    pinCenter.longitude = [[[self.locationArray objectAtIndex:index] objectForKey:@"longitude"] doubleValue];
    
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = SX;
    mapSpan.longitudeDelta = SY;
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = pinCenter;
    mapRegion.span = mapSpan;
    
    [jMapView setRegion:mapRegion];
    [jMapView regionThatFits:mapRegion];
}

/*
- (void) updateMapWithAnnotations:(NSMutableArray *) array
{
    NSLog(@"updateMapWithAnnotations");

    NSMutableArray * annotations = [[NSMutableArray alloc]init];
    for ( int index = 0; index < [array count]; index ++)
    {
        CLLocationCoordinate2D pinCenter;
        pinCenter.latitude = [[[array objectAtIndex:index] objectForKey:@"latitude"] doubleValue];
        pinCenter.longitude = [[[array objectAtIndex:index] objectForKey:@"longitude"] doubleValue];
        
        Annotation * annotation = [[Annotation alloc]initWithCoordinate:pinCenter];
        annotation.title = [[array objectAtIndex:index] objectForKey:@"name"];
        annotation.subtitle = [[array objectAtIndex:index] objectForKey:@"created_time"];
        
        [annotations addObject:annotation];
        [annotation release];
    }
    [jMapView addAnnotations:annotations];
    [annotations release];
}
*/

- (void) updateMap
{
    NSMutableArray * annotations = [[NSMutableArray alloc]init];
    for ( int index = 0; index < [self.locationArray count]; index ++)
    {
        CLLocationCoordinate2D pinCenter;
        pinCenter.latitude = [[[self.locationArray objectAtIndex:index] objectForKey:@"latitude"] doubleValue];
        pinCenter.longitude = [[[self.locationArray objectAtIndex:index] objectForKey:@"longitude"] doubleValue];
        
        Annotation * annotation = [[Annotation alloc]initWithCoordinate:pinCenter];
        annotation.title = [[self.locationArray objectAtIndex:index] objectForKey:@"name"];
        annotation.subtitle = [[self.locationArray objectAtIndex:index] objectForKey:@"created_time"];
        
        [annotations addObject:annotation];
        [annotation release];
    }
    [jMapView addAnnotations:annotations];
    [annotations release];
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
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    jMapView = [[MKMapView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    jMapView.mapType = MKMapTypeStandard;
    jMapView.userInteractionEnabled = YES;
    jMapView.delegate = self;
    [self.view addSubview:jMapView];
    [self updateMap];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self updateMap];
}
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
