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

- (NSArray *)busItemsForRoute:(NSString *)routeId {
    
    NSLog(@"About to call tripsForRoute");
    NSDictionary *tripsDict = [bench tripsForRoute:routeId];
    
    NSArray *tripsList = [[tripsDict objectForKey:@"data"] objectForKey:@"list"];
    
    NSLog(@"Got the trips!");
    NSLog(@"Trips: %@", tripsList);
    
    NSMutableArray *busItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary* trip in tripsList) {
                
        NSString *activeTripId = [trip objectForKey:@"tripId"];
//        NSLog(@"id: %@", activeTripId);
        
        // get the trip details from the API
        NSDictionary* tripDetailsDict = [bench tripDetailsForTrip:activeTripId];
//        NSLog(@"tripDetails: %@", tripDetailsDict);

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
        
        BusItem *busItem = [[BusItem alloc] initWithLatitude:[pos objectForKey:@"lat"]
                                                   Longitude:[pos objectForKey:@"lon"]
                                                       Route:@"Route 6"
                                                     andName:tripName];
        
        NSLog(@"tripName: %@", tripName);
        
        [busItems addObject:busItem];
    }
    
//    NSLog(@"busItems: %@", busItems);
    
    return busItems;
}

@end
