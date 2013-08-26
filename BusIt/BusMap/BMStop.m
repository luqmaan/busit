//
//  BMStop.m
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BMStop.h"

@implementation BMStop

@synthesize title, subtitle, coordinate, identifier;

-(id)initWithStopData:(NSDictionary *)stopData
{
    identifier = stopData[@"id"];
    subtitle = stopData[@"name"];
    title = [NSString stringWithFormat:@"%@ %@", stopData[@"code"], stopData[@"direction"]];
    coordinate = CLLocationCoordinate2DMake(
                                            [(NSNumber *)[stopData objectForKey:@"lat"] floatValue],
                                            [(NSNumber *)[stopData objectForKey:@"lon"] floatValue]);
    return self;
}

@end
