//
//  BMCircularAnnotationView.h
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BMCircularAnnotationView : MKAnnotationView {
    double hue;
    UIColor *bgColor;
    UIColor *bgEndColor;
    UIColor *borderColor;
    UIColor *textColor;
    NSString *text;
    CGFloat borderWidth;
    CGFloat width;
    CGFloat height;
    CGFloat radius;
    CGFloat fontSize;
    NSDictionary *stringAttrs;
}

@end
