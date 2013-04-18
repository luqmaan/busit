//
//  BusItem.m
//  BusStop
//
//  Created by Lolcat on 18/04/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusItem.h"

@implementation BusItem

@synthesize coordinate, title, subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D)location routeName:(NSString *)routeName
{
    
    self = [super init];
    
    if (self != nil) {
        coordinate = location;
        title = routeName;
        subtitle = @"";
    }
    NSLog(@"Did Init BusItem: %@", self);    
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}


@end
