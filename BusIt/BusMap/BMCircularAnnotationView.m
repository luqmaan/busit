//
//  BMCircularAnnotationView.m
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BMCircularAnnotationView.h"

@implementation BMCircularAnnotationView

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
    if(self) {
        // setup frame
        CGRect frame = self.frame;
        frame.size = CGSizeMake(self->width,self->height);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        textColor = [UIColor whiteColor];
        borderColor = [UIColor whiteColor];
        bgColor = [UIColor colorWithHue:hue saturation:0.5 brightness:0.853 alpha:1];
        bgEndColor = [UIColor colorWithHue:hue saturation:0.931 brightness:0.5 alpha:1];
        
        [self.layer setBorderColor:[UIColor blackColor].CGColor];
    }
    return self;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
    [self setCanShowCallout:YES];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat radius = 5.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
                    radius, M_PI, M_PI / 2, 1); //STS fixed
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
                    rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
                    radius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
                    -M_PI / 2, M_PI, 1);

    CGContextClosePath(context);
    CGContextClip(context);
    
    CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)bgColor.CGColor, (id)bgEndColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(NULL, colors, NULL);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    gradient = NULL;
}

- (void) drawString:(NSString*)string
             inRect:(CGRect)contextRect
{
    // should be defined by child class
    return;
}

@end
