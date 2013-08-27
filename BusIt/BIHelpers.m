//
//  BIHelpers.m
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BIHelpers.h"

@implementation BIHelpers

+ (void)drawCornersAroundView:(UIView *)view
{
    view.layer.cornerRadius = 10;
//    NSLog(@"self: %@", self);
//    // http://stackoverflow.com/questions/4847163/round-two-corners-in-uiview
//    // Create the mask image you need calling the previous function
//    UIImage *mask = MTDContextCreateRoundedMask( view.bounds, 10.0, 10.0, 0.0, 0.0 );
//    // Create a new layer that will work as a mask
//    CALayer *layerMask = [CALayer layer];
//    layerMask.frame = view.bounds;
//    // Put the mask image as content of the layer
//    layerMask.contents = (id)mask.CGImage;
//    // set the mask layer as mask of the view layer
//    view.layer.mask = layerMask;
}

+ (void)drawAllCornersAroundView:(UIView *)view
{
    view.layer.cornerRadius = 10.0f;
}

static inline UIImage* MTDContextCreateRoundedMask( CGRect rect, CGFloat radius_tl, CGFloat radius_tr, CGFloat radius_bl, CGFloat radius_br ) {
    
    CGContextRef context;
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a bitmap graphics context the size of the image
    context = CGBitmapContextCreate( NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast );
    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);
    
    if ( context == NULL ) {
        return NULL;
    }
    
    // cerate mask
    
    CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
    CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
    
    CGContextBeginPath( context );
    CGContextSetGrayFillColor( context, 1.0, 0.0 );
    CGContextAddRect( context, rect );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    CGContextSetGrayFillColor( context, 1.0, 1.0 );
    CGContextBeginPath( context );
    CGContextMoveToPoint( context, minx, midy );
    CGContextAddArcToPoint( context, minx, miny, midx, miny, radius_bl );
    CGContextAddArcToPoint( context, maxx, miny, maxx, midy, radius_br );
    CGContextAddArcToPoint( context, maxx, maxy, midx, maxy, radius_tr );
    CGContextAddArcToPoint( context, minx, maxy, minx, midy, radius_tl );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef bitmapContext = CGBitmapContextCreateImage( context );
    CGContextRelease( context );
    
    // convert the finished resized image to a UIImage
    UIImage *theImage = [UIImage imageWithCGImage:bitmapContext];
    // image is retained by the property setting above, so we can
    // release the original
    CGImageRelease(bitmapContext);
    
    // return the image
    return theImage;
}

+ (NSString *)timeWithTimestamp:(NSString *)timestampString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"EDT"];
    formatter.dateStyle = NSDateFormatterNoStyle;
    double time = [timestampString doubleValue] / 1000.0;
    formatter.DateFormat = @"h:mm";
    NSString* result = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    return result;
}

+ (NSString *)formattedDistanceFromStop:(NSNumber *)distanceFromStop
{
    float meters = [distanceFromStop floatValue];
    float miles = meters * 0.000621371192;
    NSString *distanceString = [NSString stringWithFormat:@"%.2f", miles];
    return distanceString;
}

+ (BOOL)isBelowiOS7
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return YES;
    }
    return NO;
}

+ (double)hueForStop:(int)stopNumber
{
    return  (stopNumber % 30) / 30.0;
}

+ (double)hueForRoute:(int)routeNumber
{
    return (routeNumber % 10) / 10.0;
}

@end
