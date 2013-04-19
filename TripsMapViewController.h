//
//  TripsMapViewController.h
//  BusStop
//
//  Created by Robert Ries on 4/14/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusAnnotation.h"
#import "BusAnnotationView.h"
#import "TripData.h"

#define METERS_PER_MILE 1609.344

@interface TripsMapViewController : UIViewController <MKMapViewDelegate, TripDataDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
