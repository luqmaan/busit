//
//  BMRouteMapViewController.m
//  BusIt
//
//  Created by Luq on 11/8/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BMRouteMapViewController.h"

@interface BMRouteMapViewController ()

@end

@implementation BMRouteMapViewController

@synthesize mapView;

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
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    [self zoomIntoTampa];
    self.shapes = [self.route fetchShape];
    BMRouteOverlayPathRenderer *pathRenderer = [[BMRouteOverlayPathRenderer alloc] initWithShapes:self.shapes];
    [mapView addOverlay:pathRenderer];
//    MKMapPoint* points = malloc(sizeof(MKMapPoint) * self.shapes.count);
    CLLocationCoordinate2D* points = malloc(sizeof(CLLocationCoordinate2D) * self.shapes.count);
    for (int i = 0; i < self.shapes.count; i++) {
    }
    MKPolyline *line = [MKPolyline polylineWithCoordinates:points count:self.shapes.count];
    [self.mapView addOverlay:line];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *line = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:line];
    routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.lineWidth = 2.0;
        NSLog(@"%@", overlay);
        return routeRenderer;
    }
    else return nil;
}


- (void)zoomIntoTampa
{
    [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 27.977727;
    zoomLocation.longitude = -82.454109;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10.5*METERS_PER_MILE, 10.5*METERS_PER_MILE);
    [mapView setRegion:viewRegion animated:YES];
}


@end
