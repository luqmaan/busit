//
//  BIBusMapOptions.m
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BMOptions.h"

@interface BMOptions() {
    NSArray *routeKeys;
}

@end

@implementation BMOptions

-(BMOptions *)init {
    self = [super init];
    if (self) {
        visibleRoutes = [[NSMutableDictionary alloc] init];
        routeKeys = [NSArray arrayWithObjects:@"routeId", @"shortName", @"longName", nil];
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
     *  }
     */
    NSArray *values = [NSArray arrayWithObjects: routeId,
                       shortName, longName, nil];
    NSMutableDictionary *route = [NSDictionary dictionaryWithObjects:values
                                                             forKeys:routeKeys];
    [visibleRoutes setObject:route forKey:routeId];
}

- (void) removeRoute:(NSString *)routeId
{
    [visibleRoutes removeObjectForKey:routeId];
}

- (BOOL)isVisibleRoute:(NSString *)routeId
{
    return visibleRoutes[routeId] != nil;
}

@end