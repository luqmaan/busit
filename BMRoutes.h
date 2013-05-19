//
//  BMRoutes.h
//  BusStop
//
//  Created by Lolcat on 19/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMVehicle.h"

@interface BMRoutes : NSObject {
    NSMutableDictionary *routes;
}

- (void) addRouteWithRoutesDict:(NSDictionary *)routesDict;

-(void) addRoute:(NSString *)routeId
       shortName:(NSString *)shortName
        longName:(NSString *)longName;

-(void) removeRoute:(NSString *)routeId;

-(void) addVehicle:(BMVehicle *)vehicle;

-(void) removeVehicle:(BMVehicle *)vehicle;

@end
