//
//  BMStopAnnotationView.m
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BMStopAnnotationView.h"
#import "BMStop.h"

@implementation BMStopAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pinSize = 25.0;
        fontSize = 12.0;
        hue = (double)rand() / RAND_MAX;
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self) {
        BMStop *stop = (BMStop *)annotation;
        text = stop.title;
    }
    return self;
}


@end
