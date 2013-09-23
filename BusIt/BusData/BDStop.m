//
//  BDStop.m
//  BusIt
//
//  Created by Lolcat on 9/1/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BDStop.h"

@implementation BDStop

@synthesize gtfsId, obaId, location, direction, name, code, locationType, wheelChairBoarding, routeIds, arrivals, distance, hue, arrivalKeys;

- (BDStop *)initWithGtfsResult:(NSDictionary *)resultDict
{
    self = [super init];
    if (self) {
        gtfsId = resultDict[@"stop_id"];
        // Unsure how I will handle this for multiple cities.
        obaId = [NSString stringWithFormat:@"%@%@", regionPrefix, gtfsId];
        location = [[CLLocation alloc] initWithLatitude:[resultDict[@"stop_lat"] floatValue]
                                              longitude:[resultDict[@"stop_lon"] floatValue]];
        name = resultDict[@"stop_name"];
        code = resultDict[@"stop_id"];
        distance = resultDict[@"distance"];
        hue = ([code intValue] % 30) / 30.0;
        arrivals = [[NSMutableDictionary alloc] init];
//        direction = nil;
//        obaId = nil;
//        locationType = nil;
//        wheelChairBoarding = nil;
//        routeIds = nil;
    }
    return self;
}

- (void)fetchArrivalsAndPerformCallback:(void(^)(void))completion {
    
    // Remove previous arrivals data
    NSLog(@"called fetchArrivalsAnd");
    [arrivals removeAllObjects];
    NSLog(@"called fetchArrivalsAnd");

    // Find the arrivals for this stop between a time range.
    BDBusData *busData = [[BDBusData alloc] init];
    
    // Get the start/stop time.
    NSDateFormatter *DateFormatter= [[NSDateFormatter alloc] init];
    NSDate *startTime = [NSDate date];
    NSDate *stopTime = [NSDate date];
    
    // Use the current time (startTime) to determine the serviceId for today,
    [DateFormatter setDateFormat:@"EEEE"];
    NSString *serviceIdQuery = [NSString stringWithFormat:@"SELECT * FROM calendar WHERE \"%@\" = 1", [DateFormatter stringFromDate:startTime]];
    NSLog(@"serviceIdQuery %@", serviceIdQuery);
    FMResultSet *serviceIdRs = [[busData database] executeQuery:serviceIdQuery];
    NSString *serviceId;
    while ([serviceIdRs next]) {
        NSLog(@"serviceIdRs: %@", [serviceIdRs resultDictionary]);
        serviceId = [serviceIdRs objectForColumnName:@"service_id"];
    }
    
    // Search between 1 hour ago and 2 hours later.
    startTime = [startTime dateByAddingTimeInterval:-05*60*60];
    stopTime = [stopTime dateByAddingTimeInterval:1.5*60*60];
    
    // Get midnight.
    // http://stackoverflow.com/questions/9040319/how-can-i-get-an-nsdate-object-for-today-at-midnight
    NSDate *midnight = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    midnight = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:midnight]];
    midnight = [midnight dateByAddingTimeInterval:-1];
    
    // Limit the query to no later than midnight.
    stopTime = [stopTime earlierDate:midnight];
    
    [DateFormatter setDateFormat:@"HH:mm:ss"];
    
    // We need to find trips that arrive at this stop within the time range and are on this day of the week.
    NSString *query = [NSString stringWithFormat:@"SELECT stop_times.*, trips.* FROM stop_times INNER JOIN trips ON stop_times.trip_id = trips.trip_id WHERE stop_times.stop_id = '%@' AND stop_times.arrival_time BETWEEN '%@' AND '%@' AND service_id = '%@' ORDER BY trips.route_id ASC, stop_times.arrival_time ASC", gtfsId, [DateFormatter stringFromDate:startTime], [DateFormatter stringFromDate:stopTime], serviceId];

    
    NSLog(@"Query: %@", query);
    FMResultSet *rs = [[busData database] executeQuery:query];
    
    while ([rs next]) {
        // For each arrival in the result set, initialize a BDArrival.
        // Add the arrival to the arrivals dictionary.
        // Group them within the dict by tripHeadsign.
        NSDictionary *arrivalDict = [rs resultDictionary];
        BDArrival *arrival = [[BDArrival alloc] initWithGtfsResult:arrivalDict];
        NSString *key = [self arrivalKeyForStopSequence:arrival.stopSequence routeId:arrival.routeId tripHeadsign:arrival.tripHeadsign];
        NSLog(@"key: %@", key);
        if (![arrivals objectForKey:key]) {
            [arrivals setObject:[[NSMutableArray alloc] init] forKey:key];
        }
        [[arrivals objectForKey:key] addObject:arrival];
        NSLog(@"ADD arrival %@ %@ %@", arrival.tripHeadsign, arrival.routeId, arrival.scheduledArrivalTime);
    }
    
    arrivalKeys = [[arrivals allKeys] mutableCopy];
    // Sort the arrivals alphabetically. By using the the routeId as the first number in the key.
    [arrivalKeys sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        int route1 = [[obj1 componentsSeparatedByString:@"___"][0] intValue];
        int route2 = [[obj2 componentsSeparatedByString:@"___"][0] intValue];
        
        if (route1 > route2)
            return (NSComparisonResult)NSOrderedDescending;
        else if (route1 < route2)
            return (NSComparisonResult)NSOrderedAscending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // Asynchronously fetch the arrival Data from the OBA API.
    // Update the appropriate BDArrivals object with the given data.
    // When this process is complete, run the callback block.

    dispatch_queue_t fetchAPIData = dispatch_queue_create("com.busit.arrivals", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(fetchAPIData, ^{
        BIRest *bench = [[BIRest alloc] init];
        NSLog(@"Gettig oba arrivals");
        NSDictionary *obArrivals = [bench arrivalsAndDeparturesForStop:obaId];
        for (NSDictionary *arrivalAndDeparture in obArrivals[@"data"][@"entry"][@"arrivalsAndDepartures"]) {
            // For each arrivalAndDeparture
            // Match it to the already existing (I think) BDArrival.
            // Tell that arrival to update itself with the OBA data.
            NSString *key = [self arrivalKeyForStopSequence:arrivalAndDeparture[@"stopSequence"]
                                                    routeId:[busData stringWithoutRegionPrefix:arrivalAndDeparture[@"routeId"]]
                                               tripHeadsign:[busData stringWithoutRegionPrefix:arrivalAndDeparture[@"tripHeadsign"]]];
            NSLog(@"obaKey is %@", key);
            NSString *tripId = [busData stringWithoutRegionPrefix:arrivalAndDeparture[@"tripId"]];
            NSLog(@"tripId = %@", tripId);
            NSPredicate *findMatchingArrival = [NSPredicate predicateWithFormat:@"SELF.identifier == %@", tripId];
            BDArrival *arrival = [[arrivals objectForKey:key] filteredArrayUsingPredicate:findMatchingArrival][0];
            NSLog(@"found arrival match %@", [arrivals objectForKey:key]);
            [arrival updateWithOBAData:arrivalAndDeparture];
            NSLog(@"arrival's vehicleId %@", arrival.vehicleId);
        }
        dispatch_async(dispatch_get_main_queue(), ^ {
            NSLog(@"Got OBA Arrivals");
            completion();
        });
    });
    
}

- (NSString *)arrivalKeyForStopSequence:(NSNumber *)stopSequence routeId:(id)routeId tripHeadsign:(NSString *)tripHeadsign
{
    NSString *key = [NSString stringWithFormat:@"%@___%@%d", routeId, stopSequence, [tripHeadsign integerValue]];
    NSLog(@"key is %@", key);
    return key;
}

@end
