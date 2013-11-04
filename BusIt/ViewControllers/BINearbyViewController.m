//
//  BINearbyViewController.m
//  BusStop
//
//  Created by Lolcat on 8/3/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BINearbyViewController.h"

@interface BINearbyViewController () {
    CLLocation *location;
    BOOL updateInProgress;
    BOOL performSegueAfterScroll;
}

@property (weak, nonatomic) BMEmbeddedMapViewController *embeddedMapView;
@property (nonatomic, retain) CLLocation *location;
@property BIBusData *busData;
@property NSArray *stops;

@end

@implementation BINearbyViewController

@synthesize location, embeddedMapView, busData, stops;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        busData = [[BIBusData alloc] init];
        updateInProgress = YES;
        performSegueAfterScroll = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"%@", self.view.subviews);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


// Hide the navigationBar for this view
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)refreshBtnPress:(id)sender {
    // Find the center of the mapView and request coordinates within that region.
    [self updateLocationToMapCenter];
    [self updateData];
}


# pragma mark - Data/API

- (void)updateData
{
    NSLog(@"Updating data.");
    updateInProgress = TRUE;

    dispatch_queue_t fetchAPIData = dispatch_queue_create("com.busit.stops", DISPATCH_QUEUE_SERIAL);

    dispatch_async(fetchAPIData, ^{
        NSLog(@"Finding stops near location %@", location);
        stops = [busData stopsNearLocation:location andLimit:50];
        dispatch_async(dispatch_get_main_queue(), ^ {
            updateInProgress = FALSE;
            [self.tableView reloadData];
            [self updateMapView];
        });
    });
}

# pragma mark - Map View

- (void)updateLocationToMapCenter
{
    CLLocationCoordinate2D center = embeddedMapView.mapView.centerCoordinate;
    location = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
    NSLog(@"Updated map center to location");
}

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

- (BIStop *)dataForIndexPath:(NSIndexPath *)indexPath
{
    return stops[indexPath.row];
}

// Maps stop codes to index paths. Used to connect the stops on the map back to rows in the datasource.
- (NSIndexPath *)indexPathForStopCode:(NSNumber *)stopCode
{
    // find the indexPath for the row that contains the stop code specified
    int i = 0;
    for (BIStop *stop in stops) {
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

    BIStop *stop = [self dataForIndexPath:indexPath];

    stopId.text = [stop.code stringValue];
    stopName.text = stop.name;

    UIColor *stopColor = self.view.window.tintColor;
    stopId.textColor = stopColor;
    stopId.layer.borderColor = [BIHelpers adjustColor:stopColor brightness:1.0 alpha:0.5].CGColor;
    stopId.layer.borderWidth = 1;
    stopId.layer.cornerRadius = 3;

    distance.text = [NSString stringWithFormat:@"%.02fmi", [stop.distance floatValue]];

    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StopDetailsSegue"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        BIStop *stop = [self dataForIndexPath:path];
        BIStopDetailsViewController *stopDetailsVC = segue.destinationViewController;
        stopDetailsVC.stop = stop;
    }
    if ([[segue identifier] isEqualToString:@"EmbeddedMapViewSegue"]) {
        embeddedMapView = segue.destinationViewController;
        NSLog(@"embedded mapview: %@", embeddedMapView);
        embeddedMapView.didUpdateLocationBlock = ^(){
            NSLog(@"called didUpdateLocationBlock()");
            [self updateLocationToMapCenter];
            [self updateData];
        };
    }
}

@end
