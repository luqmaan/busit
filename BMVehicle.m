//
//  BIVehicle.m
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BMVehicle.h"

@implementation BMVehicle

@synthesize title, subtitle, vehicleId, coordinate, lastUpdateTime, tripId, orientation, nextStop, nextStopName, nextStopTimeOffset, tripHeadsign, routeShortName, routeLongName, routeId;

-(id)initWithJSON:(NSDictionary *)vehicleData
       andAPIData:(NSDictionary * __strong*)apiData {
    
    // apiData is passed as a pointer to object so as to avoid creating multiple copies of a large object
    // apiData is an istance variable of BusMapViewController, so to pass it by reference with ARC, we must specify __strong
    // http://stackoverflow.com/questions/8814718/handling-pointer-to-pointer-ownership-issues-in-arc
    
    self = [super init];
    if(self) {
        
        // generic vehicle info
        vehicleId = [vehicleData objectForKey:@"vehicleId"];
        tripId = [vehicleData objectForKey:@"tripId"];
        
        // trip status info
        NSDictionary *tripStatus = [vehicleData objectForKey:@"tripStatus"];
        orientation = (NSNumber *)[tripStatus objectForKey:@"orientation"];
        nextStop = [tripStatus objectForKey:@"nextStop"];
        nextStopTimeOffset = (NSNumber *)[tripStatus objectForKey:@"nextStopTimeOffset" ];
        NSTimeInterval timestamp = [(NSNumber*)[tripStatus objectForKey:@"lastUpdateTime"] doubleValue];
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
        NSNumber *nextStopMins = [NSNumber numberWithInt:floor([nextStopTimeOffset floatValue]/60)];
        NSNumber *nextStopSecs = [NSNumber numberWithInt:([nextStopTimeOffset intValue]%60)];
        NSString *nextStopTime = [NSString stringWithFormat:@"%@m %@s", nextStopMins, nextStopSecs];
        if ([nextStopMins intValue] == 0) {
            nextStopTime = [NSString stringWithFormat:@"%@s", nextStopSecs];
        }
        
        // add data for the annotation
        title = [NSString stringWithFormat:@"%@ - %@", routeShortName, tripHeadsign];
        subtitle = [NSString stringWithFormat:@"Arriving in %@ at %@", nextStopTime, nextStopName];
        NSDictionary *loc = [vehicleData objectForKey:@"location"];
        coordinate = CLLocationCoordinate2DMake(
                                                [(NSNumber *)[loc objectForKey:@"lon"] floatValue],
                                                [(NSNumber *)[loc objectForKey:@"lat"] floatValue]);
    }
    return self;
}

-(NSDictionary *)findDictionaryWithKey:(NSString *)key
                              andValue:(NSString *)value
                           inReference:(NSString *)reference
                           withAPIData:(NSDictionary * __strong*)apiData
{
    // http://stackoverflow.com/questions/5846271/iphone-searching-nsarray-of-nsdictionary-objects
    // filter the very large array contained in the reference (trips, stops, routes, agencies) and find the object that dictionary that
    NSString *filter = [NSString stringWithFormat:@"%@ like '%@'", key, value];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filter];
    
    NSArray *matches = [[[[*apiData objectForKey:@"data"] objectForKey:@"references"]
                         objectForKey:reference] filteredArrayUsingPredicate:predicate];
    
    return [matches objectAtIndex:0];
}

- (NSString *)description {      
    NSString *desc = [NSString stringWithFormat:@"<BMVehicle(%@): %@ - %@>", vehicleId, title, subtitle];
    return desc;
}
//
//- (void)updateVehicle:(BMVehicle *)newVehicle
//{
//    [UIView animateWithDuration:1.0f animations:^(void){
//        self.coordinate = newVehicle.coordinate;
//    }
//                     completion:^(BOOL finished) {
//                         [self setCoordinate:newVehicle.coordinate];
//                     }];
//    
//}


- (void)updateVehicle:(BMVehicle *)newVehicle
{
    /* Somewhere we need to add logic to handle the case where a bus has reached the transit center and turns into another route. The vehicle id remains the same. And the routeId can even be changed below. However, the bus will show up in the wrong BMRoutes collection in the ViewController.
     */
    
    [UIView animateWithDuration:2.0f animations:^(void){
        //the animation only works when you say self.coordinate, why/
        self.coordinate = newVehicle.coordinate;
     }
     completion:^(BOOL finished) {
         // these fields could change (and some will definitely change)
         self.title = newVehicle.title;
         self.subtitle = newVehicle.subtitle;
         self.orientation = newVehicle.orientation;
         self.tripHeadsign = newVehicle.tripHeadsign;
         self.lastUpdateTime = newVehicle.lastUpdateTime;
         self.nextStopName = newVehicle.nextStopName;
         self.routeShortName = newVehicle.routeShortName;
         self.routeLongName = newVehicle.routeLongName;
         self.routeId = newVehicle.routeId;
         self.nextStopTimeOffset = newVehicle.nextStopTimeOffset;
         self.tripId = newVehicle.tripId;
     }];
    
}


@end

