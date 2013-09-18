//
//  BDStop.m
//  BusIt
//
//  Created by Lolcat on 9/1/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BDStop.h"

@implementation BDStop

@synthesize gtfsId, obaId, location, direction, name, code, locationType, wheelChairBoarding, routeIds, arrivals, distance, hue;

- (BDStop *)initWithGtfsResult:(NSDictionary *)resultDict
{
    self = [super init];
    if (self) {
        gtfsId = resultDict[@"stop_id"];
        location = [[CLLocation alloc] initWithLatitude:[resultDict[@"stop_lat"] floatValue]
                                              longitude:[resultDict[@"stop_lon"] floatValue]];
        name = resultDict[@"stop_name"];
        code = resultDict[@"stop_id"];
        distance = resultDict[@"distance"];
        hue = ([code intValue] % 30) / 30.0;
//        direction = nil;
//        obaId = nil;
//        locationType = nil;
//        wheelChairBoarding = nil;
//        routeIds = nil;
//        arrivals = nil;
    }
    return self;
}


@end
