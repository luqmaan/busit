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
        gtfsId = [NSString stringWithFormat:@"%@", resultDict[@"trip_id"]];
        identifier = gtfsId;
        obaId = [NSString stringWithFormat:@"%@%@", regionPrefix, gtfsId];
        scheduledArrivalTime = [BDBusData dateFromGtfsTimestring:resultDict[@"arrival_time"]];
        scheduledDepartureTime = [BDBusData dateFromGtfsTimestring:resultDict[@"departure_time"]];
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
    hasObaData = YES;
    vehicleId = obaData[@"vehicleId"];
    lastUpdateTime = [BIRest dateFromObaTimestamp:obaData[@"lastUpdateTime"]];
    predictedDepartureTime = [BIRest dateFromObaTimestamp:obaData[@"predictedDepartureTime"]];
    predictedArrivalTime = [BIRest dateFromObaTimestamp:obaData[@"predictedArrivalTime"]];
    position = [[CLLocation alloc] initWithLatitude:[obaData[@"tripStatus"][@"position"][@"lat"] doubleValue] longitude:[obaData[@"tripStatus"][@"position"][@"lon"] doubleValue]];
    numberOfStopsAway = obaData[@"numberOfStopsAway"];
    scheduleDeviation = obaData[@"tripStatus"][@"scheduleDeviation"];
    distanceAlongTrip = obaData[@"tripStatus"][@"distanceAlongTrip"];
    scheduledDistanceAlongTrip = obaData[@"tripStatus"][@"scheduledDistanceAlongTrip"];
    totalDistanceAlongTrip = obaData[@"tripStatus"][@"totalDistanceAlongTrip"];
    distanceFromStop = obaData[@"distanceFromStop"];
    nextStopTimeOffset = obaData[@"tripStatus"][@"nextStopTimeOffset"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Arrival: %@ %@>", identifier, tripHeadsign];
}

- (NSString *)formattedScheduleDeviation
{
    // http://developer.onebusaway.org/modules/onebusaway-application-modules/1.0.1/apidocs/org/onebusaway/realtime/api/VehicleLocationRecord.html#getScheduleDeviation()
    int deviation = [scheduleDeviation doubleValue] / 60;
    NSString *relative;
    
    if (deviation < 0)
        relative = @"early";
    else if (deviation > 0)
        relative = @"late";
    else
        return @"On time";
    
    deviation = abs(deviation);
    NSString *mins = @"mins";
    if (deviation == 1)
        mins = @"min";
    
    return [NSString stringWithFormat:@"%d %@ %@", deviation, mins, relative];
}

- (NSString *)formattedDistanceFromStop
{
    float meters = [distanceFromStop floatValue];
    float miles = meters * 0.000621371192;
    NSString *distanceString = [NSString stringWithFormat:@"%.2fmi away", miles];
    return distanceString;
}

@end
