//
//  BDArrivals.h
//  BusIt
//
//  Created by Lolcat on 9/1/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BDBusData.h"
#import "BIRest.h"

@interface BDArrival : NSObject

@property (nonatomic, assign) BOOL hasObaData;
@property NSString *identifier;
@property NSString *gtfsId;
@property NSString *obaId;
@property NSString *routeId;
@property NSString *vehicleId;
@property NSDate *scheduledArrivalTime;
@property NSDate *scheduledDepartureTime;
@property NSDate *predictedArrivalTime;
@property NSDate *predictedDepartureTime;
@property NSDate *updatedTime;
@property NSString *direction;
@property NSString *tripHeadsign;
@property NSNumber *serviceId;
@property NSNumber *shapeId;
@property NSNumber *stopSequence;
@property NSNumber *distanceFromStop;
@property NSNumber *numberOfStopsAway;
@property CLLocation *position;
@property NSDate *lastUpdateTime;
@property NSNumber *scheduleDeviation;
@property NSNumber *distanceAlongTrip;
@property NSNumber *scheduledDistanceAlongTrip;
@property NSNumber *totalDistanceAlongTrip;
@property NSNumber *nextStopTimeOffset;

- (id)initWithGtfsResult:(NSDictionary *)resultDict;
- (void)updateWithOBAData:(NSDictionary *)obaData;
- (NSString *)formattedScheduleDeviation;
- (NSString *)formattedDistanceFromStop;

@end
