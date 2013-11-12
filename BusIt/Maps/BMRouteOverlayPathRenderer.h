//
//  BMRouteOverlayPathRenderer.h
//  BusIt
//
//  Created by Luq on 11/8/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BMRouteOverlayPathRenderer : MKOverlayPathRenderer <MKOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;

@property NSArray *shapes;
- (id)initWithShapes:(NSArray *)shapes;

@end


