//
//  BMRoutes.m
//  BusStop
//
//  Created by Lolcat on 19/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BMRoutes.h"

@interface BMRoutes() {
    NSMutableDictionary *routes;
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

- (void)addRouteWithRoutesDict:(NSDictionary *)routesDict
{
    [self addRoute:routesDict[@"id"]
         shortName:routesDict[@"shortName"]
          longName:routesDict[@"longName"]];
}

- (void)addRoute:(NSString *)routeId
       shortName:(NSString *)shortName
        longName:(NSString *)longName
{
    /* Create a new route with this structure:
     *  routeId {
     *      routeId: @"",
     *      shortName: @"",
     *      longName: @"",
     *      vehicles: [
     *          vehicleId: BMVehicle, 
     *          BMVehicle, 
     *          BMVehicle...
     *      ]
     *  }
     */
    
    // if the route is already created, don't recreate it
    if (routes[routeId] != nil)
        return;
    
    NSArray *values = [NSArray arrayWithObjects: routeId,
                       shortName, longName, [[NSMutableDictionary alloc] init], nil];
    NSMutableDictionary *route = [NSMutableDictionary dictionaryWithObjects:values
                                                                    forKeys:routeKeys];
    [routes setObject:route forKey:routeId];
}

- (void)removeRoute:(NSString *)routeId
{
    [routes removeObjectForKey:routeId];
}

- (void)addVehicle:(BMVehicle *)vehicle
{
    [routes[vehicle.routeId][@"vehicles"] setObject:vehicle forKey:vehicle.vehicleId];
}

- (void)removeVehicle:(BMVehicle *)vehicle
{
    [routes[vehicle.routeId][@"vehicles"] removeObjectForKey:vehicle.vehicleId];
}

- (BOOL)hasVehicle:(BMVehicle *)vehicle
{
    BOOL hasVehicle = FALSE;
    id matchedVehicle = routes[vehicle.routeId][@"vehicles"][vehicle.vehicleId];
    hasVehicle = ! [matchedVehicle isEqual:nil];
    NSString *hasVehicleString = hasVehicle ? @"Yes" : @"No";
    NSLog(@"hasVehicle: %@ %@ ==> %@", hasVehicleString, vehicle, matchedVehicle);
    return hasVehicle;
}
- (void)updateVehicle:(BMVehicle *)newVehicle
{
    [[routes[newVehicle.routeId][@"vehicles"] objectForKey:newVehicle.vehicleId] updateVehicle:newVehicle];
}

- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    NSEnumerator *routesEnumerator = [routes keyEnumerator];
    id routeKey;
    while ((routeKey = [routesEnumerator nextObject]))
    {
        [description appendFormat:@"\n%@ => ", routeKey];
        NSEnumerator *vehicleEnumerator = [routes[routeKey][@"vehicles"] keyEnumerator];
        id vehicleKey;
        while ((vehicleKey = [vehicleEnumerator nextObject]))
        {
            [description appendFormat:@"%@ ", vehicleKey];
        }
    }
    return [NSString stringWithFormat:@"%@", description];
}

@end
