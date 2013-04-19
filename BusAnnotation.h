//
//  BusAnnotation.h
//  BusStop
//
//  Created by Lolcat on 18/04/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BusAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

-(id) initWithLatitude:(NSNumber*)lat Longitude:(NSNumber*)lon Route:(NSString *)routeName andName:(NSString *)tripName;

@end
