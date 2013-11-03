//
//  BIRoute.h
//  BusIt
//
//  Created by Lolcat on 9/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIStop.h"
#import "BIHelpers.h"

@interface BIRoute : NSObject

@property NSNumber *routeId;
@property NSString *routeShortName;
@property NSString *routeLongName;
@property NSNumber *routeType;
@property NSString *routeUrl;
@property UIColor *routeColor;
@property UIColor *routeTextColor;
@property (nonatomic, assign) float hue;

- (BIRoute *)initWithGtfsResult:(NSDictionary *)resultDict;
- (NSArray *)stops;

/** TODO: implement a search tool to allow searching for a stop without viewing all of them. Perhaps this can be done in the  */
- (NSArray *)stopsMatchingQuery:(NSString *)query;

@end
