//
//  BITripViewController.h
//  BusIt
//
//  Created by Luq on 11/22/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BIRoute.h"
#import "BITrip.h"
#import "ShapeReducer.h"
#import <QuartzCore/QuartzCore.h>

#define METERS_PER_MILE 1609.344

@interface BITripViewController : UIViewController <MKMapViewDelegate>

@property BIRoute *route;
@property BITrip *trip;
@property Shape *shape;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarTitle;

@end
