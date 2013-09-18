//
//  BNNearbyViewController.m
//  BusStop
//
//  Created by Lolcat on 8/3/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BNNearbyViewController.h"

@interface BNNearbyViewController () {
    CLLocationManager *locationManager;
    CLLocation *location;
    BOOL updateInProgress;
    BOOL performSegueAfterScroll;
}

@property (weak, nonatomic) BMEmbeddedMapViewController *embeddedMapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *location;
@property BDBusData *busData;
@property NSArray *stops;

@end

@implementation BNNearbyViewController

@synthesize locationManager, location, embeddedMapView, busData, stops;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        busData = [[BDBusData alloc] init];
        updateInProgress = YES;
        performSegueAfterScroll = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startStandardUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshBtnPress:(id)sender {
    [self startStandardUpdates];
}


#pragma mark - Location & API

- (void)startStandardUpdates
{
    NSLog(@"Starting standard updates");
    self.navigationController.navigationItem.prompt = @"Finding location";
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100;
    [locationManager startUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;    
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)locManager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    location = newLocation;
    NSLog(@"New location: %f %f", location.coordinate.longitude, location.coordinate.latitude);
    // only update the location once
    [locationManager stopUpdatingLocation];
    [self updateAPIData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManagerdidFailWithError: %@", error);
}

- (void)updateAPIData
{
    NSLog(@"Started updating api data");
    self.navigationItem.prompt = @"Found location, fetching nearby stops";
    updateInProgress = TRUE;
    
    
    dispatch_queue_t fetchAPIData = dispatch_queue_create("com.busit.stops", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(fetchAPIData, ^{
        stops = [busData stopsNearLocation:location andLimit:200];
        dispatch_async(dispatch_get_main_queue(), ^ {
            updateInProgress = FALSE;
            [self.tableView reloadData];
            self.navigationItem.prompt = nil;
            [self updateMapView];
        });
    });
}

# pragma mark - Map View

- (void)updateMapView
{
    [embeddedMapView addStopsToMap:stops];
}

- (void)performSegueForMapViewWithStop:(NSNumber *)stopCode
{
    NSIndexPath *indexPath = [self indexPathForStopCode:stopCode];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    performSegueAfterScroll = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (performSegueAfterScroll) {
        performSegueAfterScroll = NO;
        [self performSegueWithIdentifier:@"StopDetailsSegue" sender:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (updateInProgress)
        return 1;
    return [stops count];
}

- (BDStop *)dataForIndexPath:(NSIndexPath *)indexPath
{
    return stops[indexPath.row];
}

// Maps stop codes to index paths. Used to connect the stops on the map back to rows in the datasource.
- (NSIndexPath *)indexPathForStopCode:(NSNumber *)stopCode
{
    // find the indexPath for the row that contains the stop code specified
    int i = 0;
    for (BDStop *stop in stops) {
        if (stop.code == stopCode) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            return indexPath;
        }
        i++;
    }
    return nil;
}

#pragma mark - Segues & Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *stopId = (UILabel *)[cell viewWithTag:1];
    UILabel *stopName = (UILabel *)[cell viewWithTag:2];
    UILabel *distance = (UILabel *)[cell viewWithTag:3];
    
    if (updateInProgress) {
        NSLog(@"Called cell for row at indexpath, but update is in progress");
        stopId.text = @"";
        stopName.text = @"Loading...";
        return cell;
    }

    BDStop *stop = [self dataForIndexPath:indexPath];

    stopId.text = [stop.code stringValue];
    stopName.text = stop.name;

    UIColor *stopColor = [UIColor colorWithHue:stop.hue saturation:1 brightness:0.7 alpha:1];;
    stopId.textColor = stopColor;
    stopId.layer.borderColor = stopColor.CGColor;
    stopId.layer.borderWidth = 1;
    stopId.layer.cornerRadius = 3;
    
    distance.text = [NSString stringWithFormat:@"%.02fmi", [stop.distance floatValue]];
    
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    if ([identifier isEqualToString:@"StopDetailsSegue"]) {
        NSLog(updateInProgress ? @"UpdateInProgress: YES" : @"UpdateInProgress: NO");
        if (updateInProgress) {
            NSLog(@"Update in progress, DONT perform segue");
            return NO;
        }
    }
    NSLog(@"YES perform segue");
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StopDetailsSegue"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        BDStop *stop = [self dataForIndexPath:path];
        BNArrivalsTableViewController *stopDetailsVC = segue.destinationViewController;
        stopDetailsVC.stop = stop;
    }
    if ([[segue identifier] isEqualToString:@"EmbeddedMapViewSegue"]) {
        embeddedMapView = segue.destinationViewController;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
