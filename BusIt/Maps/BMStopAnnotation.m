//
//  BMStop.m
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BMStopAnnotation.h"

@implementation BMStopAnnotation

@synthesize title, subtitle, coordinate, identifier, hue;

-(id)initWithStop:(BIStop *)stop
{
    identifier = [stop.code stringValue];
    subtitle = stop.name;
    title = [stop.code stringValue];
    coordinate = stop.location.coordinate;
    hue = stop.hue;
    return self;
}

@end
