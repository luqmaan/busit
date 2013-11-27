//
//  BITripViewController.m
//  BusIt
//
//  Created by Luq on 11/22/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BITripViewController.h"

@interface BITripViewController ()

@end

@implementation BITripViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shape = [self.route shapeForTrip:self.trip];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.navigationItem.title = self.route.routeLongName;
    self.tripTitle.text = self.trip.tripHeadsign;
    MKPolyline *line = [MKPolyline polylineWithCoordinates:self.shape.coordinates count:self.shape.points.count];
    NSLog(@"Ading overlay with %lu points", (unsigned long)self.shape.points.count);
    [self.mapView addOverlay:line];
    self.mapView.region = self.shape.region;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *line = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:line];
        routeRenderer.strokeColor = [UIColor colorWithHue:0.589 saturation:1 brightness:1.0 alpha:0.8];
        routeRenderer.lineWidth = 3.0;
        return routeRenderer;
    }
    return nil;
}

@end
