//
//  BusAnnotationView.m
//  BusStop
//
//  Created by Lolcat on 18/04/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusAnnotationView.h"

@implementation BusAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"init with frame");
    }
    return self;
}


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"init with annotation");
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(20.0, 20.0);
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *icon = [UIImage imageNamed:@"bus_icon.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = frame;
        
        [self addSubview:imageView];
    }
    return self;
}

@end
