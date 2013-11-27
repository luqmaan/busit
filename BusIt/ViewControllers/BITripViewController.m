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
    self.toolbarTitle.title = self.trip.tripHeadsign;
    
    CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * self.shape.points.count);
    int i = 0;
    for (ShapePoint *point in self.shape.points) {
        coordinateArray[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        i++;
    }
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coordinateArray count:self.shape.points.count];
    NSLog(@"%lu points", (unsigned long)self.shape.points.count);
    [self.mapView addOverlay:line];
    free(coordinateArray);
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
    else return nil;
}

- (void)zoomIntoTampa
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 27.977727;
    zoomLocation.longitude = -82.454109;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10.5*METERS_PER_MILE, 10.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}

@end
