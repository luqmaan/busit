//
//  BDArrivals.m
//  BusIt
//
//  Created by Lolcat on 9/1/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BDArrival.h"

@interface BDArrival () {}
    @property BDBusData *busData;
@end

@implementation BDArrival

@synthesize gtfsId, obaId, obaTripId, routeId, vehicleId, scheduledArrivalTime, scheduledDepartureTime, predictedTime, updatedTime, vehicles, direction, tripHeadsign, serviceId, shapeId, stopSequence;

@synthesize busData;

- (id)initWithGtfsResult:(NSDictionary *)resultDict
{
    self = [super init];
    if (self) {
        gtfsId = resultDict[@"trip_id"];
        obaId = nil;
        obaTripId = nil;
        scheduledArrivalTime = resultDict[@"arrival_time"];
        scheduledDepartureTime = resultDict[@"departure_time"];
        routeId = [resultDict[@"route_id"] stringValue];
        direction = resultDict[@"direction"];
        tripHeadsign = resultDict[@"trip_headsign"];
        serviceId = resultDict[@"service_id"];
        shapeId = resultDict[@"shape_id"];
        stopSequence = resultDict[@"stop_sequence"];
    }
    return self;    
}

- (void)updateWithOBAData:(NSDictionary *)obaData {
    vehicleId = nil;
    predictedTime = nil;
    updatedTime = nil;
    vehicles = nil;
}

@end
