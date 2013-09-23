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

@synthesize gtfsId, obaId, routeId, vehicleId, scheduledArrivalTime, scheduledDepartureTime, predictedArrivalTime, predictedDepartureTime, updatedTime, direction, tripHeadsign, serviceId, shapeId, stopSequence, distanceFromStop, numberOfStopsAway, position, lastUpdateTime, scheduleDeviation, distanceAlongTrip, scheduledDistanceAlongTrip, totalDistanceAlongTrip, nextStopTimeOffset, hasObaData, identifier;

@synthesize busData;

- (id)initWithGtfsResult:(NSDictionary *)resultDict
{
    self = [super init];
    if (self) {
        hasObaData = NO;
        gtfsId = resultDict[@"trip_id"];
        identifier = gtfsId;
        obaId = [NSString stringWithFormat:@"%@%@", regionPrefix, gtfsId];
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
    NSLog(@"Update with OBA Data");
    vehicleId = obaData[@"vehicleId"];
    lastUpdateTime = [BIRest dateFromObaTimestamp:obaData[@"lastUpdateTime"]];
    predictedDepartureTime = [BIRest dateFromObaTimestamp:obaData[@"predictedDepartureTime"]];
    predictedArrivalTime = [BIRest dateFromObaTimestamp:obaData[@"predictedArrivalTime"]];
    position = [[CLLocation alloc] initWithLatitude:[obaData[@"tripStatus"][@"position"][@"lat"] doubleValue] longitude:[obaData[@"tripStatus"][@"position"][@"lon"] doubleValue]];
    numberOfStopsAway = obaData[@"tripStatus"][@"numberOfStopsAway"];
    scheduleDeviation = obaData[@"tripStatus"][@"scheduleDeviation"];
    distanceAlongTrip = obaData[@"tripStatus"][@"distanceAlongTrip"];
    scheduledDistanceAlongTrip = obaData[@"tripStatus"][@"scheduledDistanceAlongTrip"];
    totalDistanceAlongTrip = obaData[@"tripStatus"][@"totalDistanceAlongTrip"];
    distanceFromStop = [BIRest formattedDistanceFromStop:obaData[@"distanceFromStop"]];
    nextStopTimeOffset = obaData[@"tripStatus"][@"nextStopTimeOffset"];
    hasObaData = YES;
}



@end
