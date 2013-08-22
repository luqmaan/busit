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
}

@property (nonatomic, retain) BIRest *bench;
@property (nonatomic, retain) NSDictionary *apiData;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *location;

@end

@implementation BNNearbyViewController

@synthesize apiData, bench, locationManager, location;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        bench = [[BIRest alloc] init];
        apiData = [[NSDictionary alloc] init];
        updateInProgress = TRUE;
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
    self.navigationController.navigationItem.prompt = @"Updating location";
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
    NSLog(@"Start Updating api data");
    self.navigationItem.prompt = @"Found location, fetching data";
    updateInProgress = TRUE;
    apiData = [bench stopsForLocationLat:[NSNumber numberWithFloat:location.coordinate.latitude]
                                     Lon:[NSNumber numberWithFloat:location.coordinate.longitude]];
    updateInProgress = FALSE;
    NSLog(@"Stop Updating api data");
    NSLog(@"reload tableview");
    self.navigationItem.prompt = nil;
    [self.tableView reloadData];
    NSLog(@"Did reload tableview");
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

-(NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    if (updateInProgress)
        return nil;
    return apiData[@"data"][@"list"][indexPath.row];
}

#pragma mark - Segues & Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row at indexpath %@", indexPath);
    static NSString *CellIdentifier = @"StopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *stopId = (UILabel *)[cell viewWithTag:1];
    UILabel *stopName = (UILabel *)[cell viewWithTag:2];
    UILabel *direction = (UILabel *)[cell viewWithTag:4];
    UILabel *routes = (UILabel *)[cell viewWithTag:3];
    
    if (updateInProgress) {
        NSLog(@"cell for row at indexpath, but update in progress");
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
    direction.text = stopData[@"direction"];
    NSMutableString *routesText = [NSMutableString stringWithString:@"Routes "];
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
    if ([identifier isEqualToString:@"stopDetailSegue"]) {
        if (updateInProgress)
            return NO;
    }
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
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
