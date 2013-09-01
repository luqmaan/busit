//
//  BDBusData.h
//  BusIt
//
//  Created by Lolcat on 8/30/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BDBusData : NSObject

-(BMStop *)stopWithCode:(NSNumber *)code;
-(BMStop *)stopWithObaId:(NSNumber *)obaId;
-(BMStop *)stopWithGtfsId:(NSNumber *)gtfsId;
-(NSArray *)stopNearLocation:(CLLocationCoordinate2D)location andRadius:(CGFLoat)miles;

-(BMRoute *)routeWithObaId:(NSNumber *code);
-(BMRoute *)routeWithGtfsId:(NSNumber *code);
-(BMRoute *)routeWithShortName:(NSNumber *obaId);

@end
