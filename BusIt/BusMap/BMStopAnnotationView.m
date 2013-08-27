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
        width = 55.0;
        height = 15.0;
        fontSize = 12.0;
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self) {
        BMStop *stop = (BMStop *)annotation;
        text = stop.title;
        hue = ([stop.identifier intValue] % 30) / 30.0;
        bgColor = [UIColor colorWithHue:hue saturation:0.85 brightness:0.853 alpha:1];
        bgEndColor = [UIColor colorWithHue:hue saturation:0.931 brightness:0.5 alpha:1];
        NSLog(@"hue: %f identifier: %@", hue, stop.identifier);
    }
    return self;
}


- (void) drawString:(NSString*)string
             inRect:(CGRect)contextRect
{
    // http://stackoverflow.com/questions/1302824/iphone-how-to-draw-text-in-the-middle-of-a-rect
    [textColor set];
    
    CGRect textRect = CGRectMake(0, 0, contextRect.size.width, contextRect.size.height);
    
    NSLog(@"contextHeight: %f", contextRect.size.height);
    
    NSLog(@"string: %@", string);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    [style setAlignment:NSTextAlignmentCenter];
    float lineHeight = 16;
    [style setMaximumLineHeight:lineHeight];
    [style setMinimumLineHeight:lineHeight];
    [style setLineSpacing:0.0f];
    [string drawInRect:textRect
        withAttributes:@{
                         NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Demibold" size:fontSize],
                         NSForegroundColorAttributeName: [UIColor whiteColor],
                         NSParagraphStyleAttributeName: style,
                         NSKernAttributeName: [NSNumber numberWithFloat:-1.0f]
                         }];
    
}


@end
