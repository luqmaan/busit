//
//  BIVehicle.h
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BMVehicle : NSMutableDictionary <MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    NSString *vehicleId;
    CLLocationCoordinate2D coordinate;
    NSDate *lastUpdateTime;
    NSString *tripId;
    NSNumber *orientation;
    NSString *nextStop;
    NSString *nextStopName;
    NSNumber *nextStopTimeOffset;
    NSString *tripHeadsign;
    NSString *routeShortName;
    
    NSString *routeLongName;
    NSString *routeId;
}

-(id)initWithJSON:(NSDictionary *)vehicleData
       andAPIData:(NSDictionary **)apiData;

@end
