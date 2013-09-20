//
//  BDStop.h
//  BusIt
//
//  Created by Lolcat on 9/1/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BDBusData.h"
#import "BDArrival.h"

@interface BDStop : NSObject {
}

@property (nonatomic, retain) NSNumber *gtfsId;
@property (nonatomic, retain) NSString *obaId;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *direction;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *code;
@property (nonatomic, retain) NSNumber *locationType;
@property (nonatomic, retain) NSString *wheelChairBoarding;
@property (nonatomic, retain) NSArray *routeIds; // array of BDRoutes
@property (nonatomic, retain) NSMutableArray *arrivals;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, assign) double hue;

//-(BDStop *)initWithCode:(NSNumber *)code;
//-(BDStop *)initWithObaId:(NSNumber *)obaId;
//-(BDStop *)initWithGtfsId:(NSNumber *)gtfsId;
- (BDStop *)initWithGtfsResult:(NSDictionary *)resultDict;
- (void)fetchArrivalsAndPerformCallback:(void(^)(void))completion;

@end
