//
//  BMRoutes.m
//  BusStop
//
//  Created by Lolcat on 19/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BMRoutes.h"

@interface BMRoutes() {
    NSArray *routeKeys;
}
@end

@implementation BMRoutes

- (id)init {
    self = [super init];
    if (self) {
        routes = [[NSMutableDictionary alloc] init];
        routeKeys = [NSArray arrayWithObjects:@"routeId", @"shortName", @"longName", @"vehicles", nil];
    }
    return self;
}

- (void) addRouteWithRoutesDict:(NSDictionary *)routesDict
{
    [self addRoute:routesDict[@"id"]
         shortName:routesDict[@"shortName"]
          longName:routesDict[@"longName"]];
}

- (void) addRoute:(NSString *)routeId
       shortName:(NSString *)shortName
        longName:(NSString *)longName
{
    /* Create a new route with this structure:
     *  routeId {
     *      routeId: @"",
     *      shortName: @"",
     *      longName: @"",
     *      vehicles: [BMVehicle, BMVehicle, BMVehicle...]
     *  }
     */
    NSArray *values = [NSArray arrayWithObjects: routeId,
                       shortName, longName, [[NSMutableDictionary alloc] init], nil];
    NSMutableDictionary *route = [NSDictionary dictionaryWithObjects:values
                                                             forKeys:routeKeys];
    [routes setObject:route forKey:routeId];
}

- (void) removeRoute:(NSString *)routeId
{
    [routes removeObjectForKey:routeId];
}

- (void) addVehicle:(BMVehicle *)vehicle
{
    [routes[vehicle.routeId][@"vehicles"] setObject:vehicle forKey:vehicle.vehicleId];
}

- (void) removeVehicle:(BMVehicle *)vehicle
{
    [routes[vehicle.routeId][@"vehicles"] removeObjectForKey:vehicle.vehicleId];
}
@end
