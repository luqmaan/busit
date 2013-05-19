//
//  BusMapViewController.h
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStopREST.h"
#import "BMVehicle.h"
#import "BMOptions.h"
#import "BMRoutes.h"

#define METERS_PER_MILE 1609.344

@interface BusMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
