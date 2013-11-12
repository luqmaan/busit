//
//  BITrip.m
//  BusIt
//
//  Created by Luq on 11/10/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BITrip.h"

@implementation BITrip

- (id)initWithGTFSResult:(NSDictionary *)rs
{
    self = [super init];
    if (self) {
        self.id = rs[@"id"];
        self.routeId = rs[@"route_id"];
        self.serviceId = rs[@"service_id"];
        self.tripId = rs[@"trip_id"];
        self.tripHeadsign = rs[@"trip_headsign"];
        self.blockId = rs[@"block_id"];
        self.shapeId = rs[@"shape_id"];
        self.directionId = rs[@"direction_id"];
        self.direction = rs[@"direction"];
    }
    return self;
}

@end
