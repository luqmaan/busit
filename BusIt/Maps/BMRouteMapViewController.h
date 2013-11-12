//
//  BMRouteMapViewController.h
//  BusIt
//
//  Created by Luq on 11/8/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BIRoute.h"
#import "BMRouteOverlayPathRenderer.h"

#define METERS_PER_MILE 1609.344

@interface BMRouteMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property BIRoute *route;
@property NSArray *shapes;

@end
