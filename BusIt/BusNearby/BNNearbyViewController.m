//
//  BNNearbyViewController.m
//  BusStop
//
//  Created by Lolcat on 8/3/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BNNearbyViewController.h"

@interface BNNearbyViewController () {
    NSDictionary *apiData;
    BIRest *bench;
    CLLocationManager *locationManager;
    CLLocation *location;
    BOOL updateInProgress;
    BOOL performSegueAfterScroll;
}

@property (weak, nonatomic) BMEmbeddedMapViewController *embeddedMapView;
@property (nonatomic, retain) BIRest *bench;
@property (nonatomic, retain) NSDictionary *apiData;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *location;
@property BDBusData *busData;

@end

@implementation BNNearbyViewController

@synthesize apiData, bench, locationManager, location, embeddedMapView, busData;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        busData = [[BDBusData alloc] init];
        NSLog(@"busData %@", busData);
        bench = [[BIRest alloc] init];
        apiData = [[NSDictionary alloc] init];
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
    
    [busData stopsNearLocation:location andLimit:15];
    
    dispatch_queue_t fetchAPIData = dispatch_queue_create("com.busit.stops", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(fetchAPIData, ^{
        apiData = [bench stopsForLocationLat:[NSNumber numberWithFloat:location.coordinate.latitude]
                                         Lon:[NSNumber numberWithFloat:location.coordinate.longitude]];
        dispatch_async(dispatch_get_main_queue(), ^ {
            NSLog(@"Finished updating API data");
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
    [embeddedMapView addStopsToMap:apiData];
}

- (void)performSegueForMapViewWithStop:(NSString *)stopCode
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
    return [apiData[@"data"][@"list"] count];
}

- (NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath
{
    return apiData[@"data"][@"list"][indexPath.row];
}

- (NSIndexPath *)indexPathForStopCode:(NSString *)stopCode
{
    // find the indexPath for the row that contains the stop code specified
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:0];
    for (int i = 0; i < rowCount; i++) {
        if (apiData[@"data"][@"list"][i][@"code"] == stopCode) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            return indexPath;
        }
    }
    return nil;
}

#pragma mark - Segues & Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell for row at indexpath %@", indexPath);
    static NSString *CellIdentifier = @"StopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *stopId = (UILabel *)[cell viewWithTag:1];
    UILabel *stopName = (UILabel *)[cell viewWithTag:2];
    UILabel *direction = (UILabel *)[cell viewWithTag:4];
    UILabel *routes = (UILabel *)[cell viewWithTag:3];
    
    if (updateInProgress) {
        NSLog(@"Cell for row at indexpath, but update in progress");
        stopId.text = @"";
        direction.text = @"";
        routes.text = @"";
        stopName.text = @"Loading...";
        cell.accessoryView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSDictionary *stopData = [self dataForIndexPath:indexPath];
    NSArray *routesArray = apiData[@"data"][@"references"][@"routes"];
    stopId.text = stopData[@"code"];
    stopName.text = stopData[@"name"];
    double hue = [BIHelpers hueForStop:[stopData[@"code"] intValue]];
    stopName.textColor = [UIColor colorWithHue:hue saturation:1 brightness:0.7 alpha:1];
    direction.text = stopData[@"direction"];
    NSMutableString *routesText = [NSMutableString stringWithString:@""];
    id lastRouteId = [stopData[@"routeIds"] lastObject];
    for (NSString *routeId in stopData[@"routeIds"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", routeId];
        NSArray *filtered = [routesArray filteredArrayUsingPredicate:predicate];
        if (routeId == lastRouteId)
            [routesText appendFormat:@"%@", filtered[0][@"shortName"]];            
        else
            [routesText appendFormat:@"%@ ", filtered[0][@"shortName"]];

    }
    routes.text = routesText;
    
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    if ([identifier isEqualToString:@"StopDetailsSegue"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSDictionary *stopData = [self dataForIndexPath:path];
//        NSLog(@"stopData: %@", stopData);
        NSLog(updateInProgress ? @"UpdateInProgress: YES" : @"UpdateInProgress: NO");
        if (updateInProgress) {
            NSLog(@"Update in progress, DONT perform segue");
            return NO;
        }
        if (stopData == nil) {
            NSLog(@"Stop data is empty, DONT perform SEGUE");
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
        NSDictionary *stopData = [self dataForIndexPath:path];
        BNArrivalsTableViewController *stopDetailsVC = segue.destinationViewController;
        stopDetailsVC.stopData = stopData;
    }
    if ([[segue identifier] isEqualToString:@"EmbeddedMapViewSegue"]) {
        embeddedMapView = segue.destinationViewController;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
