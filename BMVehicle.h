//
//  BIVehicle.h
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <objc/runtime.h> // used for -description

@interface BMVehicle : NSObject <MKAnnotation> {
    @public NSString *title;
    @public NSString *subtitle;
    @public NSString *vehicleId;
    @public CLLocationCoordinate2D coordinate;
    @public NSDate *lastUpdateTime;
    @public NSString *tripId;
    @public NSNumber *orientation;
    @public NSString *nextStop;
    @public NSString *nextStopName;
    @public NSNumber *nextStopTimeOffset;
    @public NSString *tripHeadsign;
    @public NSString *routeShortName;
    @public NSString *routeLongName;
    @public NSString *routeId;
}

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *subtitle;
@property(nonatomic, retain) NSString *vehicleId;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, retain) NSDate *lastUpdateTime;
@property(nonatomic, retain) NSString *tripId;
@property(nonatomic, retain) NSNumber *orientation;
@property(nonatomic, retain) NSString *nextStop;
@property(nonatomic, retain) NSString *nextStopName;
@property(nonatomic, retain) NSNumber *nextStopTimeOffset;
@property(nonatomic, retain) NSString *tripHeadsign;
@property(nonatomic, retain) NSString *routeShortName;
@property(nonatomic, retain) NSString *routeLongName;
@property(nonatomic, retain) NSString *routeId;

-(id)initWithJSON:(NSDictionary *)vehicleData
       andAPIData:(NSDictionary * __strong*)apiData;

@end
