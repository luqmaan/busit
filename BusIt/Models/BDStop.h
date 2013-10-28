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
#import "BIRest.h"

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
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, assign) double hue;
/** Array of BDRoutes */
@property (nonatomic, retain) NSArray *routeIds;
/** Dictionary of arrivals grouped by tripHeadsign. Groups are NSMutableArray of BDArrival. */
@property (nonatomic, retain) NSMutableDictionary *arrivals;
/** Array of keys in the arrivals. Used to allow accessing of the arrivals by an indexPath. */
@property (nonatomic, retain) NSMutableArray *arrivalKeys;

- (BDStop *)initWithGtfsResult:(NSDictionary *)resultDict;
- (void)fetchArrivalsAndPerformCallback:(void(^)(void))completion progressCallback:(ProgressUpdateBlock)progressUpdateBlock;

@end
