//
//  BusStop.h
//  BusStop
//
//  Created by Lolcat on 18/04/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusStopREST.h"
#import "BusStopManager.h"
#import "BusAnnotation.h"

@interface TripData : NSObject

@property BusStopREST *bench;

- (NSArray *)busAnnotationsForRoute:(NSString *)route;

@end
