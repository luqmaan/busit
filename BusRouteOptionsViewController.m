//
//  BusRouteOptionsViewController.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusRouteOptionsViewController.h"
#import "Stop.h"
#import "RouteId.h"

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
    
    NSMutableDictionary *destRouteIds = [NSMutableDictionary dictionaryWithCapacity:0];
    for( NSDictionary *busStop in closestStopsToDestination )
    {
        for( RouteId *routeId in busStop[@"routeIds"] )
        {
            destRouteIds[routeId.routeId] = @YES;
        }
    }
    
    NSMutableDictionary *startRouteIds = [NSMutableDictionary dictionaryWithCapacity:0];
    for( NSDictionary *busStop in closestStopsToStart )
    {
        for( RouteId *routeId in busStop[@"routeIds"] )
        {
            startRouteIds[routeId.routeId] = @YES;
        }
    }
    
    NSLog(@"startRouteIds: %@", startRouteIds);
    NSLog(@"destRouteIds: %@", destRouteIds);

    NSMutableSet *set1 = [NSMutableSet setWithArray:[startRouteIds allKeys]];
    NSMutableSet *set2 = [NSMutableSet setWithArray:[destRouteIds allKeys]];
    [set1 intersectSet:set2];
    NSLog(@"routeIds in common: %@", set1);
    NSLog(@"YEA");
    
    // now we need to get these from the store.
    BusStopManager *mgr = [BusStopManager sharedManagerWithOnDiskStore];
    self.possibleRoutes = [mgr routesForIds:set1.allObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.possibleRoutes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Route *route = self.possibleRoutes[indexPath.row];
    
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
