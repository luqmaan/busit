//
//  BIVehicle.m
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BMVehicle.h"

@implementation BMVehicle

-(id)initWithJSON:(NSDictionary *)vehicleData
       andAPIData:(NSDictionary **)apiData {
    
    self = [super init];
    if(self) {
        
        // generic vehicle info
        vehicleId = [vehicleData objectForKey:@"vehicleId"];
        tripId = [vehicleData objectForKey:@"tripId"];
        
        // trip status info
        NSDictionary *tripData = [vehicleData objectForKey:@"tripData"];
        orientation = (NSNumber *)[tripData objectForKey:@"orientation"];
        nextStop = [tripData objectForKey:@"nextStop"];
        nextStopTimeOffset = (NSNumber *)[tripData objectForKey:@"nextStopTimeOffset" ];
        NSTimeInterval timestamp = [(NSNumber*)[tripData objectForKey:@"lastUpdateTime"] doubleValue];
        lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:timestamp];
        
    
        // search the data/references/trips for the tripdetails for this trip
        NSDictionary *tripDetails = [self findDictionaryWithKey:@"id"
                                                       andValue:tripId
                                                    inReference:@"trips"
                                                    withAPIData:apiData];
        tripHeadsign = [tripDetails objectForKey:@"tripHeadsign"];
        routeId = [tripDetails objectForKey:@"routeId"];
        
        // search the data/references/routes for the routedetails for this route
        NSDictionary *routeDetails = [self findDictionaryWithKey:@"id"
                                                        andValue:routeId
                                                     inReference:@"routes"
                                                     withAPIData:apiData];
        routeShortName = [routeDetails objectForKey:@"shortName"];
        routeLongName = [routeDetails objectForKey:@"longName"];
        
        // search the data/references/stops for stopdetails
        NSDictionary *stopDetails = [self findDictionaryWithKey:@"id"
                                                        andValue:nextStop
                                                     inReference:@"stops"
                                                     withAPIData:apiData];
        nextStopName = [stopDetails objectForKey:@"name"];
        NSNumber *nextStopTime = [NSNumber numberWithFloat:[nextStopTimeOffset floatValue]/60];
        
        // add data for the annotation
        title = [NSString stringWithFormat:@"%@ - %@", routeShortName, tripHeadsign];
        subtitle = [NSString stringWithFormat:@"Arriving in %@mins at %@", nextStopTime, nextStopName];
        NSDictionary *loc = [vehicleData objectForKey:@"location"];
        coordinate = CLLocationCoordinate2DMake(
                                                [(NSNumber *)[loc objectForKey:@"lat"] floatValue],
                                                [(NSNumber *)[loc objectForKey:@"lon"] floatValue]);
    }
    return self;
}

-(NSDictionary *)findDictionaryWithKey:(NSString *)key
                              andValue:(NSString *)value
                           inReference:(NSString *)reference
                           withAPIData:(NSDictionary **)apiData
{
    // http://stackoverflow.com/questions/5846271/iphone-searching-nsarray-of-nsdictionary-objects
    // filter the very large array contained in the reference (trips, stops, routes, agencies) and find the object that dictionary that
    NSString *filter = [NSString stringWithFormat:@"%@ = %@", key, value];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filter];
    
    NSArray *matches = [[[[*apiData objectForKey:@"data"] objectForKey:@"references"]
                         objectForKey:reference] filteredArrayUsingPredicate:predicate];
    
    return [matches objectAtIndex:0];
}
@end

