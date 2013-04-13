//
//  BusStopManager.m
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "BusStopManager.h"
#import "MBProgressHUD.h"
#import "BusStopREST.h"

@implementation BusStopManager

-(void)updateBusRouteDataWithCompletion:(void (^)(void))completion failure:(void (^)(void))failure
{
    BusStopREST *bench = [[BusStopREST alloc] init];
    
    // get routes and add them to CD store, including route details
    NSDictionary *routes = [bench routesForAgency];
    for( NSDictionary *route in routes[@"data"][@"list"] )
    {
        NSLog(@"route: %@", route);
        // pull out route[@"longName"], route[@"shortName"], route[@"id"], route[@"url"]
    }
    
    // for each route, get stops - name, lat/lon, direction etc.
    NSDictionary *stops = [bench stopsForRoute:@"Hillsborough Area Regional Transit_8"];
    NSLog(@"stops: %@", stops);
}

-(NSArray *)routes
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
}

-(NSArray *)stopsForRoute:(NSString *)routeId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Route"];
}

-(NSDictionary *)detailsForRoute:(NSString *)routeId
{
}

-(NSDictionary *)detailsForStop:(NSString *)routeId
{
}

@end
