//
//  RouteStopsViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BusStopAnnotation.h"
#import "BusStopAnnotationView.h"
#import "BusStopAppDelegate.h"
#import "RouteStopsViewController.h"
#import "StopScheduleViewController.h"
#import "StopCell.h"

@interface RouteStopsViewController ()

@end

@implementation RouteStopsViewController

-(void)recomputeDistances
{
    if(nil != newLocation)
    {
        int i=0;
        for( Stop *stop in self.stops )
        {
            CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:[stop.lat doubleValue] longitude:[stop.lon doubleValue]];
            double distanceInMeters = [stopLocation distanceFromLocation:newLocation];
            double distanceInMiles = distanceInMeters*0.000621371;
            self.distances[i++] = @(distanceInMiles);
            stopLocation = nil;
        }
    }
}

-(void)locationChanged:(NSNotification *)note
{
    BusStopAppDelegate *delegate = (BusStopAppDelegate *)note.object;
    newLocation = delegate.mgr.location;
    [self recomputeDistances];
    [self.stopsTable reloadData];
}

//#if 0

-(void)displayPlacemarks:(NSArray *)arrayOfPlacemarks {
    dispatch_async(dispatch_get_main_queue(), ^{
        CLPlacemark *placemark = [arrayOfPlacemarks objectAtIndex:0];
        NSLog(@"%@", placemark);
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        NSDictionary *areaOfInterest = [NSDictionary dictionaryWithDictionary:placemark.addressDictionary];
        NSString *addressSubtitle = [NSString stringWithFormat:@"%@, %@ %@", [areaOfInterest objectForKey:@"Street"], [areaOfInterest objectForKey:@"City"], placemark.administrativeArea];
        BusStopAnnotation *annotation = [[BusStopAnnotation alloc] initWithTitle:addressSubtitle andSubtitle:@"Click to advance"];
        [annotation setAlertLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
        [annotation setAlertLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
        //[self.stopMap setCenterCoordinate:coordinate];
        NSArray *existingAnnotations = [NSArray arrayWithArray:self.stopMap.annotations];
        if ([existingAnnotations count] > 0) {
            [self.stopMap removeAnnotations:existingAnnotations];
        }
        [self.stopMap addAnnotation:annotation];
    });
}

//#endif

-(void)moveMapToLocationWithLatitude:(double)lat andLongitude:(double)lon
{
    CLLocationCoordinate2D coord;
    coord.latitude = lat;
    coord.longitude = lon;
    MKCoordinateSpan span;
    span.latitudeDelta = .1/111.699;
    span.longitudeDelta = .1/111.321;
    
    MKCoordinateRegion rgn = MKCoordinateRegionMake(coord, span);
    [self.stopMap setRegion:rgn];
    [self.stopMap setCenterCoordinate:coord];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        [self displayPlacemarks:placemarks];
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@", placemark.addressDictionary[@"Street"], placemark.addressDictionary[@"City"], placemark.addressDictionary[@"State"]];
        self.addressLabel.text = str;
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"Entered viewForAnnotation");
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    if([annotation isKindOfClass:[BusStopAnnotation class]]){
        static NSString *AnnotationViewID = @"annotationViewID";
        BusStopAnnotationView *customPinView = [[BusStopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        customPinView.opaque = NO;
        return customPinView;
    }
    return nil;
}

-(void)geocodeLatitude:(double)lat andLongitude:(double)lon
{
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
    self.stops = [[self.currentRoute.stops allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Stop *stop1 = (Stop *)obj1;
        Stop *stop2 = (Stop *)obj2;
        if(stop1.code > stop2.code)
            return NSOrderedDescending;
        else
        if(stop1.code < stop2.code)
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    
    BusStopAppDelegate *app = (BusStopAppDelegate *)[[UIApplication sharedApplication] delegate];
    newLocation = app.mgr.location;
    
    self.distances = [[NSMutableArray alloc] initWithCapacity:self.stops.count];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:kLocationUpdated object:nil];
    [self recomputeDistances];
    [self.stopsTable reloadData];
    
    currentIndex = 0;
    //[self.stopsTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.stopsTable didSelectRowAtIndexPath:0];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = self.stops.count;
    return numRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StopCell *cell = (StopCell *)[tableView dequeueReusableCellWithIdentifier:@"StopCell"];
    if(nil == cell)
        cell = [[StopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StopCell"];
    
    Stop *busStop = self.stops[indexPath.row];
    cell.stopNameLabel.text = busStop.name;
    cell.stopDirectionLabel.text = busStop.direction;
    double distanceAwayInMiles = [self.distances[indexPath.row] doubleValue];
    if(distanceAwayInMiles<.10)
    {
        double distanceAwayInFeet = distanceAwayInMiles * 5280.0;
        cell.stopDistanceLabel.text = [NSString stringWithFormat:@"%.1f feet away", distanceAwayInFeet];
    }
    else
    if(distanceAwayInMiles<10.0)
    {
        cell.stopDistanceLabel.text = [NSString stringWithFormat:@"%.1f miles away", distanceAwayInMiles];
    }
    else
    {
        cell.stopDistanceLabel.text = [NSString stringWithFormat:@"%.0f miles away", distanceAwayInMiles];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndex = indexPath.row;
    Stop *busStop = self.stops[indexPath.row];
    [self moveMapToLocationWithLatitude:[busStop.lat doubleValue] andLongitude:[busStop.lon doubleValue]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Stop *busStop = self.stops[currentIndex];
    StopScheduleViewController *stopSchedVC = (StopScheduleViewController *)[segue destinationViewController];
    stopSchedVC.busStop = busStop;
}

#pragma mark - Map View delegates

@end
