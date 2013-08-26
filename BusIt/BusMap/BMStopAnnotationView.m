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


- (void) drawString:(NSString*)string
             inRect:(CGRect)contextRect
{
    // http://stackoverflow.com/questions/1302824/iphone-how-to-draw-text-in-the-middle-of-a-rect
    [textColor set];
    
    CGRect textRect = CGRectMake(0, 3, contextRect.size.width, contextRect.size.height * 1.5);
    
    NSLog(@"string: %@", string);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    [style setAlignment:NSTextAlignmentCenter];
    [style setMaximumLineHeight:10.5f];
    [style setLineSpacing:0.0f];
    [string drawInRect:textRect
        withAttributes:@{
                         NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:10],
                         NSForegroundColorAttributeName: [UIColor whiteColor],
                         NSParagraphStyleAttributeName: style,
                         NSKernAttributeName: [NSNumber numberWithFloat:-1.0f]
                         }];
    
}


@end
