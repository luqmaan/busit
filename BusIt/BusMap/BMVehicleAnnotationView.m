//
//  BMVehicleAnnotationView.m
//  BusStop
//
//  Created by Lolcat on 20/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.#cecece//

#import "BMVehicleAnnotationView.h"
#import "BMVehicle.h"

@implementation BMVehicleAnnotationView
{
    BMVehicle *vehicle;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        width = 25.0;
        height = width;
        radius = width / 2.0f;
        fontSize = 13.0;
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self){
        vehicle = (BMVehicle *) annotation;
        
        text = vehicle.routeShortName;
        
        // set the color based on the route number
        int num = vehicle.routeShortName.intValue;
        hue = (num % 10) / 10.0;
        double saturation = ((num % 7) / 14.0) + 0.3;
        bgColor = [UIColor colorWithHue:hue saturation:saturation brightness:0.853 alpha:1];
        bgEndColor = [UIColor colorWithHue:hue saturation:0.931 brightness:0.5 alpha:1];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByClipping];
        [style setAlignment:NSTextAlignmentCenter];
        CGFloat lineHeight = 21;
        [style setMaximumLineHeight:lineHeight];
        [style setMinimumLineHeight:lineHeight];
        stringAttrs = @{
            NSFontAttributeName: [UIFont fontWithName:@"Avenir-Black" size:fontSize],
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSParagraphStyleAttributeName: style,
            NSKernAttributeName: [NSNumber numberWithFloat:-1.0f]
        };
    }
    return self;
}



@end
