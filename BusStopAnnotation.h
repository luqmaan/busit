//
//  BusStopAnnotation.h
//  BusStop
//
//  Created by Adam Lowther on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BusStopAnnotation : NSObject <MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSNumber *alertLatitude;
@property (nonatomic, strong) NSNumber *alertLongitude;
@property (nonatomic, strong) NSString *alertDirection;
@property (nonatomic, strong) NSString *alertCode;
@property (nonatomic, strong) NSString *alertName;
@property (nonatomic, strong) NSString *alertID;


-(id)initWithCoordinate:(CLLocationCoordinate2D)setCoordinate;

@end
