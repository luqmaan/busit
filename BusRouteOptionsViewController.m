//
//  BusRouteOptionsViewController.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusRouteOptionsViewController.h"

@interface BusRouteOptionsViewController ()

@end

@implementation BusRouteOptionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:28.06193110 longitude:-82.41392803];
    CLLocation *starting = [[CLLocation alloc] initWithLatitude:28.06457550 longitude:-82.41806000];
    //NSLog(@"Destination: %@", _destinationPlacemark);
    //NSLog(@"Starting: %@", _startingPlacemark);
    BusStopManager *stopManager = [BusStopManager sharedManagerWithOnDiskStore];
    NSArray *closestStopsToDestination = [NSArray arrayWithArray:[stopManager stopsClosestToLatitude:destination.coordinate.latitude andLogitude:destination.coordinate.longitude withinMeters:500 limit:10]];
    NSArray *closestStopsToStart = [NSArray arrayWithArray:[stopManager stopsClosestToLatitude:starting.coordinate.latitude andLogitude:starting.coordinate.longitude withinMeters:500 limit:10]];
//    NSArray *closestStops = [NSArray arrayWithArray:[stopManager stopsClosestToLatitude:_startingPlacemark.location.coordinate.latitude andLogitude:_startingPlacemark.location.coordinate.longitude withinMeters:500 limit:5]];
    NSLog(@"%@", closestStopsToDestination);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end
