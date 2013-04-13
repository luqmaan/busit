//
//  UserStartAnnotation.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "UserStartAnnotation.h"

@implementation UserStartAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)setCoordinate{
    self = [super init];
    if(self) {
        coordinate = setCoordinate;
    }
    return self;
}

-(id)initWithTitle:(NSString *)titleToSet andSubtitle:(NSString *)subtitleToSet {
    self = [super init];
    if(self != nil) {
        title = titleToSet;
        subtitle = subtitleToSet;
    }
    return self;
}

-(NSString *)title {
    return title;
}

-(NSString *)subtitle {
    return subtitle;
}

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = [self.alertLatitude doubleValue];
    coordinate.longitude = [self.alertLongitude doubleValue];
    return coordinate;
}

@end
