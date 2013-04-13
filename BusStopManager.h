//
//  BusStopManager.h
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStopManager : NSObject

-(void)updateBusRouteData;
-(NSArray *)routes;
-(NSArray *)stopForRoute:(NSString *)routeId;
-(NSDictionary *)detailsForRoute:(NSString *)routeId;

@end
