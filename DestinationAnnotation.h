//
//  DestinationAnnotation.h
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DestinationAnnotation : NSObject <MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSNumber *alertLatitude;
@property (nonatomic, strong) NSNumber *alertLongitude;
@property (nonatomic, strong) NSString *alertName;

-(id)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle;

@end
