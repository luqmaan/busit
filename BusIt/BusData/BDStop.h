//
//  BDStop.h
//  BusIt
//
//  Created by Lolcat on 9/1/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDArrivals.h"

@interface BDStop : NSObject {
    NSNumber *gtfsId;
    NSString *obaId;
    CLLocationCoordinate2D location;
    NSString *direction;
    NSString *name;
    NSNumber *code;
    NSNumber *locationType;
    NSString *wheelChairBoarding;
    NSArray *routeIds; // array of BDRoutes
    BDArrivals *arrivals;
}



- (id)initWithGtfs:(NSDictionary *)gtfsData andOba:(NSDictionary *)obaData;

@end
