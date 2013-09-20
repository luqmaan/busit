//
//  BDArrivals.h
//  BusIt
//
//  Created by Lolcat on 9/1/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBusData.h"

@interface BDArrival : NSObject

@property NSString *gtfsId;
@property NSString *obaId;
@property NSString *obaTripId;
@property NSString *routeId;
@property NSString *vehicleId;
@property NSNumber *pickup_type;
@property NSNumber *drop_off_type;
@property NSDate *scheduledArrivalTime;
@property NSDate *scheduledDepartureTime;
@property NSDate *predictedTime;
@property NSDate *updatedTime;
@property NSArray *vehicles;

- (id)initWithGtfsResult:(NSDictionary *)resultDict;

@end
