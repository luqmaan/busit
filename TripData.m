//
//  BusStop.m
//  BusStop
//
//  Created by Lolcat on 18/04/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "TripData.h"

@implementation TripData

@synthesize bench;

- (id) init {
    bench = [[BusStopREST alloc] init];
    return self;
}

- (NSArray *)busAnnotationsForRoute:(NSString *)routeId {
    
    NSLog(@"About to call tripsForRoute");
    NSDictionary *tripsDict = [bench tripsForRoute:routeId];
    
    NSArray *tripsList = [[[tripsDict objectForKey:@"data"]
                                      objectForKey:@"references"]
                                      objectForKey:@"trips"];
    
    NSLog(@"Got the trips!");
    NSLog(@"Trips: %@", tripsList);
    
    NSMutableArray *busAnnotations = [[NSMutableArray alloc] init];
    
    for (NSDictionary *trip in tripsList) {
        
        NSString *activeTripId = [trip objectForKey:@"id"];
        NSString *routeId = [trip objectForKey:@"routeId"];
        NSMutableString *routeName = [[NSMutableString alloc] initWithString:@""];
        
        for (NSDictionary *route in [[[tripsDict objectForKey:@"data"]
                                                 objectForKey:@"references"]
                                                 objectForKey:@"routes"])
        {
            if ([[route objectForKey:@"id"] isEqualToString:routeId]) {
                [routeName appendString:[route objectForKey:@"shortName"]];
                [routeName appendString:@" - "];
                [routeName appendString:[route objectForKey:@"longName"]];
                break;
            }
            
        }
        
        NSLog(@"activeTripId: %@", activeTripId);
        
        // get the trip details from the API
        sleep(1);
        NSDictionary* tripDetailsDict = [bench tripDetailsForTrip:activeTripId];
        NSLog(@"tripDetails: %@", tripDetailsDict);

        NSDictionary *status = [[[tripDetailsDict objectForKey:@"data"]
                                                  objectForKey:@"entry"]
                                                  objectForKey:@"status"];
                                                 
        // name
        NSString *tripName = @"";
        for (NSDictionary* tripMeta in [[[tripDetailsDict objectForKey:@"data"]
                                                          objectForKey:@"references"]
                                                          objectForKey:@"trips"])
        {
//            NSLog(@"Comparing %@ VS %@ \n headsign: %@ \n tripMeta: %@", [tripMeta objectForKey:@"id"], activeTripId, [tripMeta objectForKey:@"tripHeadsign"], tripMeta);
            if ([[tripMeta objectForKey:@"id"] isEqualToString:activeTripId]) {
                tripName = [tripMeta objectForKey:@"tripHeadsign"];
                break;
            }
        }
        // position
        NSDictionary *pos = [status objectForKey:@"position"];
        
        BusAnnotation *busAnnotation = [[BusAnnotation alloc] initWithLatitude:[pos objectForKey:@"lat"]
                                                   Longitude:[pos objectForKey:@"lon"]
                                                       Route:routeName
                                                     andName:tripName];
        
        NSLog(@"tripName: %@", tripName);
        [[self delegate] addAnnotationToMap:busAnnotation];
        
        //[busAnnotations addObject:busAnnotation];
    }
    
//    NSLog(@"busAnnotations: %@", busAnnotations);
    
    return busAnnotations;
}

@end
