//
//  BusItem.m
//  BusStop
//
//  Created by Lolcat on 18/04/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusAnnotation.h"

@implementation BusAnnotation

@synthesize coordinate, title, subtitle;

-(id) initWithLatitude:(NSNumber*)lat Longitude:(NSNumber*)lon Route:(NSString *)routeName andName:(NSString *)tripName
{
    
    self = [super init];
    
    if (self != nil) {
        CLLocationCoordinate2D location;
        location.latitude = [lat doubleValue];
        location.longitude = [lon doubleValue];
        NSLog(@"created the cllocation: %f %f", location.latitude, location.longitude);
        coordinate = location;
        title = routeName;
        subtitle = tripName;
    }
    NSLog(@"Did Init BusAnnotation: %@", self);
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}


@end
