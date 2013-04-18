//
//  BusRouteOptionsViewController.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusRouteOptionsViewController.h"
#import "MBProgressHUD.h"
#import "Route.h"
#import "Stop.h"
#import "RouteId.h"

@interface BusRouteOptionsViewController ()

@end

@implementation BusRouteOptionsViewController

-(void)showHUD:(NSString *)hudMsg
{
    if(nil == hud)
    {
        hud = [[MBProgressHUD alloc] init];
        hud.labelText = hudMsg;
        [self.view addSubview:hud];
        [hud show:YES];
    }
}

-(void)updateHUD:(NSString *)hudMsg
{
    hud.labelText = hudMsg;
}

-(void)hideHUD
{
    [hud hide:YES];
}
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
    
    dispatch_queue_t queue = dispatch_queue_create("hackathon", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self showHUD:@"Finding routes..."];
        });
        
        BusStopManager *stopManager = [BusStopManager sharedManagerWithOnDiskStore];
        NSArray *closestStopsToDestination = [NSArray arrayWithArray:[stopManager stopsClosestToLatitude:_destinationPlacemark.location.coordinate.latitude andLogitude:_destinationPlacemark.location.coordinate.longitude withinMeters:500 limit:10]];
        
        NSArray *closestStopsToStart = [NSArray arrayWithArray:[stopManager stopsClosestToLatitude:_startingPlacemark.location.coordinate.latitude andLogitude:_startingPlacemark.location.coordinate.longitude withinMeters:500 limit:10]];
        
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
        
        NSMutableSet *set1 = [NSMutableSet setWithArray:[startRouteIds allKeys]];
        NSMutableSet *set2 = [NSMutableSet setWithArray:[destRouteIds allKeys]];
        [set1 intersectSet:set2];
        
        BusStopManager *mgr = [BusStopManager sharedManagerWithOnDiskStore];
        self.possibleRoutes = [mgr routesForIds:set1.allObjects];

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self hideHUD];
            [self.tableView reloadData];
        });
    
    });
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
    if(nil == cell)
        cell = (UITableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = route.name;
    return cell;
}

@end
