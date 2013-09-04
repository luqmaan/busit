//
//  BDBusData.h
//  BusIt
//
//  Created by Lolcat on 8/30/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BIRest.h"
#import "BMStop.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"

@interface BDBusData : NSObject

@property (nonatomic, retain) FMDatabase *database;

- (void)updateTables;
- (NSArray *)stopsNearLocation:(CLLocationCoordinate2D)location andRadius:(CGFloat)miles;
- (NSDictionary *)vehiclesForAgency:(NSString *)agencyId;

@end
