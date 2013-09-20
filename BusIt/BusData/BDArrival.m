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

@synthesize gtfsId, obaId, obaTripId, routeId, vehicleId, pickup_type, drop_off_type, scheduledArrivalTime, scheduledDepartureTime, predictedTime, updatedTime, vehicles;
@synthesize busData;

- (id)initWithGtfsResult:(NSDictionary *)resultDict
{
    self = [super init];
    if (self) {
        gtfsId = nil;
        obaId = nil;
        obaTripId = nil;
        scheduledArrivalTime = nil;
        scheduledDepartureTime = nil;
        routeId = nil;
    }
    return self;
}

- (void)updateWithOBAData:(NSDictionary *)obaData {
    vehicleId = nil;
    pickup_type = nil;
    drop_off_type = nil;
    predictedTime = nil;
    updatedTime = nil;
    vehicles = nil;
}

@end
