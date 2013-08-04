//
//  BIBusMapOptions.h
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMOptions : NSMutableDictionary {
    NSMutableDictionary* visibleRoutes;
}

- (void) addRouteWithRoutesDict:(NSDictionary *)routesDict;
- (void)addRoute:(NSString *)routeId shortName:(NSString *)shortName longName:(NSString *)longName;
- (void)removeRoute:(NSString *)routeId;
- (BOOL)isVisibleRoute:(NSString *)routeId;

@end

