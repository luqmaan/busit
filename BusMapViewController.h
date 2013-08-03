//
//  BusMapViewController.h
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BusStopUIViewController.h"
#import "BusStopREST.h"
#import "BMVehicle.h"
#import "BMVehicleAnnotationView.h"
#import "BMOptions.h"
#import "BMRoutes.h"
#import "BMStatusView.h"

#define METERS_PER_MILE 1609.344

@interface BusMapViewController : BusStopUIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(IBAction)refreshBtnPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *statusView
;

@end
