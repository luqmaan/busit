//
//  BITrip.h
//  BusIt
//
//  Created by Luq on 11/10/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BITrip : NSObject

@property NSNumber *id;
@property NSNumber *routeId;
@property NSString *serviceId;
@property NSNumber *tripId;
@property NSString *tripHeadsign;
@property NSNumber *blockId;
@property NSNumber *shapeId;
@property NSNumber *directionId;
@property NSString *direction;

- (id)initWithGTFSResult:(NSDictionary *)rs;

@end
