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
        width = 20.0; // set in the initWithAnnotation method when string is known
        height = 20.0;
        fontSize = 13.0;
        radius = 5.0;
        borderWidth = 1.0;
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self) {
        BMStop *stop = (BMStop *)annotation;
        
        text = stop.title;
        width = [text length] * 9.0;
        [super updateFrame];
        
        hue = [BIHelpers hueForStop:[stop.identifier intValue]];
        bgColor = [UIColor colorWithHue:hue saturation:0.85 brightness:0.85 alpha:0.9];
        bgEndColor = [UIColor colorWithHue:hue saturation:0.931 brightness:0.75 alpha:1];
        borderColor = [UIColor colorWithHue:hue saturation:1 brightness:0.3 alpha:1];
        
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByClipping];
        [style setAlignment:NSTextAlignmentCenter];
        float lineHeight = 19;
        [style setMaximumLineHeight:lineHeight];
        [style setMinimumLineHeight:lineHeight];
        [style setLineSpacing:0.0f];
        stringAttrs = @{
            NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:fontSize],
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSParagraphStyleAttributeName: style,
            NSKernAttributeName: [NSNumber numberWithFloat:-1.0f]
        };
    }
    return self;
}



@end
