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
    UIColor *bgColor;
    UIColor *borderColor;
    UIColor *textColor;
    CGFloat pinSize;
    CGFloat fontSize;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self->pinSize = 25.0;
        self->fontSize = 15.0;
    }
    return self;
}


-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self){
        vehicle = (BMVehicle *) annotation;
        
        // setup frame
        CGRect frame = self.frame;
        frame.size = CGSizeMake(self->pinSize,self->pinSize);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        // give it color based on the route number
        int num = vehicle.routeShortName.intValue;
        double hue = (num % 10) / 10.0;
        double saturation = ((num % 7) / 14.0) + 0.3;
        bgColor = [UIColor colorWithHue:hue saturation:saturation brightness:0.853 alpha:1];
        borderColor = [UIColor colorWithHue:hue saturation:0.931 brightness:0.5 alpha:1];
        textColor = [UIColor whiteColor];
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
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetInterpolationQuality( context , kCGInterpolationHigh );
    
    // draw circle
    CGPathRef roundedRectPath = [self newPathForSquare:rect radius:self->pinSize/2.0f];
//    [bgColor set];
    CGContextAddPath(context, roundedRectPath);
	CGContextFillPath(context);
    CGPathRelease(roundedRectPath);
    [self drawGradient:(CGContextRef)context inRect:rect];
    
    // draw route number
    [self drawString:vehicle.routeShortName
            withFont:[UIFont fontWithName:@"Avenir-Black" size:self->fontSize]
              inRect:rect];
}

- (void) drawString:(NSString*)string
           withFont:(UIFont*)font
             inRect:(CGRect)contextRect
{
    // http://stackoverflow.com/questions/1302824/iphone-how-to-draw-text-in-the-middle-of-a-rect
    [textColor set];
    
    CGRect textRect = CGRectMake(0, 3, contextRect.size.width, contextRect.size.height);
    
    [string drawInRect:textRect
             withFont:font
        lineBreakMode:UILineBreakModeClip
            alignment:UITextAlignmentCenter];
}

- (void) drawGradient:(CGContextRef)context inRect:(CGRect)rect
{
    CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)bgColor.CGColor, (id)borderColor.CGColor, nil];

    CGGradientRef gradient = CGGradientCreateWithColors(NULL, colors, NULL);
        
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    
    CGContextDrawPath(context, kCGPathStroke);
}


- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
    // http://www.cocoanetics.com/2010/02/drawing-rounded-rectangles/

    CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width - 1;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height - 1;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y + 1;
	CGFloat outside_left = rect.origin.x + 1;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}


- (CGPathRef) newPathForSquare:(CGRect)rect radius:(CGFloat)radius
{
    // http://www.cocoanetics.com/2010/02/drawing-rounded-rectangles/
    
    CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width - 1;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height - 1;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y + 1;
	CGFloat outside_left = rect.origin.x + 1;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}

@end
