//
//  BMEmbeddedMapViewController.h
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BMStopAnnotationView.h"
#import "BMStopAnnotation.h"
#import "BDStop.H"
#import "BNNearbyViewController.h"


@interface BMEmbeddedMapViewController : UIViewController  <MKMapViewDelegate>

// not actual init's
- (void)initWithStop:(NSDictionary *)stop andBuses:(NSArray *)busList;
- (void)addStopsToMap:(NSArray *)stops;
- (void)initWithRoute:(NSArray *)route andShape:(NSDictionary *)shape;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
