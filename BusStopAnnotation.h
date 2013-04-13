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
    CLLocationCoordinate2D *coordinate;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D *)setCoordinate;

@end
