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
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"

#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180


@interface BDBusData : NSObject

@property FMDatabase *database;

- (NSArray *)stopsNearLocation:(CLLocation *)location andLimit:(int)limit;

@end
