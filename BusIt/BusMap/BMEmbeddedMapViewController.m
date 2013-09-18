//
//  BMEmbeddedMapViewController.m
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BMEmbeddedMapViewController.h"

@interface BMEmbeddedMapViewController ()

@property MKUserLocation *userLocation;

@end

@implementation BMEmbeddedMapViewController

@synthesize mapView, userLocation;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        // For some reason mapView is null here, so I set its properties in the fake init methods
    }
    return self;
}

- (void)initWithStop:(NSDictionary *)stop andBuses:(NSArray *)busList
{

}

- (void)addStopsToMap:(NSArray *)stops
{
    [self initMapView];
    // Only add annotations to the map if they are not already present.
    // It is unnecessary to remove annotations, as stops do not move or update.
    NSMutableArray *existingAnnotations = [[NSMutableArray alloc] init];
    
    // Find the existing annotation and mark their identifiers.
    for (id annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[BMStopAnnotation class]])
        {
            BMStopAnnotation *stop = (BMStopAnnotation *)annotation;
            [existingAnnotations addObject:stop.identifier];
        }
//        [mapView removeAnnotations:mapView.annotations];
    }
    
    // Add the stops with new identifiers.
    for (BDStop *stop in stops) {
        if (! [existingAnnotations containsObject:stop.code]) {
            BMStopAnnotation *annotation = [[BMStopAnnotation alloc] initWithStop:stop];
            [mapView addAnnotation:annotation];
        }
    }
}

- (void)initWithRoute:(NSArray *)route andShape:(NSDictionary *)shape
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Map

- (void)initMapView
{
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
}


# pragma mark - Annotations

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    if([annotation isKindOfClass:[BMStopAnnotation class]]){
        BMStopAnnotation *stopAnnotation = (BMStopAnnotation *)annotation;
        NSString *annotationViewID = [NSString stringWithFormat:@"StopAnnotationView%@", stopAnnotation.identifier];
        MKAnnotationView *customPinView = [theMapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
        
        if (!customPinView) {
            customPinView = [[BMStopAnnotationView alloc] initWithAnnotation:stopAnnotation reuseIdentifier:annotationViewID];
            [customPinView setCanShowCallout:YES];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            rightButton.tintColor = [UIColor colorWithHue:stopAnnotation.hue saturation:1 brightness:0.7 alpha:1];
            customPinView.rightCalloutAccessoryView = rightButton;
        }
        
        return customPinView;
    }
    
    return nil;
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view isKindOfClass:[BMStopAnnotationView class]]) {
        BNNearbyViewController *parent = (BNNearbyViewController *)[self parentViewController];
        BMStopAnnotation *stop = (BMStopAnnotation *)view.annotation;
        [parent performSegueForMapViewWithStop:stop.identifier];
    }
}

# pragma mark - Zoom

- (void)zoomToFitAnnotations
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(0, 10, 15, 10) animated:YES];
//    double minLat = -90.0;
//    double maxLat = 90.0;
//    double minLon = -180.0;
//    double maxLon = 180.0;
//
//    for (id<MKAnnotation> annotation in mapView.annotations) {
//        if (annotation.coordinate.latitude > minLat)
//            minLat = annotation.coordinate.latitude;
//        if (annotation.coordinate.latitude < maxLat)
//            maxLat = annotation.coordinate.latitude;
//        if (annotation.coordinate.longitude > minLon)
//            minLon = annotation.coordinate.longitude;
//        if (annotation.coordinate.longitude < maxLon)
//            maxLon = annotation.coordinate.longitude;
//    }
//    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
//    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake((maxLat - minLat)/2.0, (maxLon - minLon)/2.0);
//    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(locationCoordinate, span);
////    mapRegion.center = map.userLocation.coordinate;
////    mapRegion.span.latitudeDelta = 0.015;
////    mapRegion.span.longitudeDelta = 0.015;
//    [mapView setRegion:mapRegion animated: YES];
}

- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)newUserLocation
{
//    [self zoomToFitAnnotations];
    // zoom into users location once
    static BOOL didZoomIn;
    userLocation = newUserLocation;
    
    if (!didZoomIn) {
        didZoomIn = TRUE;
        [self zoomToUserLocation:nil];
    }
}

- (IBAction)zoomToUserLocation:(id)sender {
    CLLocationAccuracy accuracy = userLocation.location.horizontalAccuracy;
    if (accuracy > 0) {
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.0075;
        mapRegion.span.longitudeDelta = 0.0075;
        [mapView setRegion:mapRegion animated: YES];
    }
}

@end
