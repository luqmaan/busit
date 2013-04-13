//
//  BusStopAnnotationView.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusStopAnnotation.h"
#import "BusStopAnnotationView.h"

@implementation BusStopAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self != nil){
        CGRect frame = self.frame;
        frame.size = CGSizeMake(30.0,40.0);
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor clearColor]];
        //[self setCenterOffset:CGPointMake(30.0, 42.0)];
    }
    return self;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation{
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    NSString *pinImage = nil;//[NSString stringWithFormat:@"%@%@", pinImage, @"_blue.png"];
    [[UIImage imageNamed:pinImage] drawInRect:CGRectMake(0, 0, 30.0, 40.0)];
    
}

@end