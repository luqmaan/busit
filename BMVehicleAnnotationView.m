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
        // Initialization code
    }
    return self;
}


-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self){
        vehicle = (BMVehicle *) annotation;
        CGRect frame = self.frame;
        frame.size = CGSizeMake(15.0,15.0);
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor redColor]];
        double hue = sin(vehicle.routeShortName.intValue ^ 2);
        NSLog(@"%d %f", vehicle.routeShortName.intValue, hue);
        UIColor *bgColor = [UIColor colorWithHue:hue saturation:0.531 brightness:0.953 alpha:1];
        [self setBackgroundColor:bgColor];
        [self setOpaque:NO];
    }
    return self;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
    [self setCanShowCallout:YES];
}

- (void) drawString:(NSString*)s
           withFont:(UIFont*)font
             inRect:(CGRect)contextRect
{
    CGFloat fontHeight = font.pointSize;
    
    CGRect textRect = CGRectMake(0, 2, contextRect.size.width, fontHeight);
    
    [s drawInRect:textRect
         withFont:font
    lineBreakMode:UILineBreakModeClip
        alignment:UITextAlignmentCenter];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawString:vehicle.routeShortName
            withFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10]
              inRect:rect];
/*
    BMVehicle *alert = (BMVehicle *)self.annotation;
    if (alert != nil) {
        NSString *pinImage = [NSString stringWithFormat:@"flag_icon.png"];
        [[UIImage imageNamed:pinImage] drawInRect:CGRectMake(0, 0, 30.0, 30.0)];
    }
*/
}


@end
