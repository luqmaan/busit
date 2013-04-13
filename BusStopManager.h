//
//  BusStopManager.h
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStopManager : NSObject

-(void)updateBusRouteDataWithCompletion:(void (^)(void))completion failure:(void (^)(void))failure;
-(NSArray *)routes;
-(NSDictionary *)detailsForRoute:(NSString *)routeId;
-(NSArray *)stopsForRoute:(NSString *)routeId;
-(NSDictionary *)detailsForStop:(NSString *)routeId;

@end
