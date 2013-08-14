//
//  BIRest.h
//  BusStop
//
//  Created by Chris Woodard on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIRest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    BOOL isFinished;
    BOOL isScrewed;
}

@property (nonatomic, strong) NSMutableData *cumulativeData;

-(NSDictionary *)restToJSON:(NSString *)jsonURL paramStr:(NSString *)paramStr;
-(NSDictionary *)agencies;
-(NSDictionary *)agency;
-(NSDictionary *)routesForAgency;
-(NSDictionary *)stopsForRoute:(NSString *)routeId;
-(NSDictionary *)stop:(NSString *)stopId;
-(NSDictionary *)scheduleForStop:(NSString *)stopId;
-(NSDictionary *)tripsForRoute:(NSString *)routeId;
-(NSDictionary *)tripDetailsForTrip:(NSString *)tripId;
-(NSDictionary *)vehiclesForAgency:(NSString *)agencyId;
-(NSDictionary *)stopsForLocationLat:(NSNumber *)lat Lon:(NSNumber *)lon;
-(NSDictionary *)arrivalsAndDeparturesForStop:(NSString *)stopId;

@end

