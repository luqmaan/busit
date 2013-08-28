//
//  BMEmbeddedMapViewController.m
//  BusIt
//
//  Created by Lolcat on 8/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BMEmbeddedMapViewController.h"
#import "BMStopAnnotationView.h"
#import "BMStop.h"
#import "BNNearbyViewController.h"

@interface BMEmbeddedMapViewController ()

@end

@implementation BMEmbeddedMapViewController

@synthesize mapView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        // For some reason mapView is null here, so I set its properties in the fake init methods
    }
    return self;
}

- (void)initWithStop:(NSDictionary *)stop andBuses:(NSArray *)busList
{

}

- (void)addStopsToMap:(NSDictionary *)apiData
{
    [self initMapView];
    // Only add annotations to the map if they are not already present.
    // It is unnecessary to remove annotations, as stops do not move or update.
    NSMutableArray *existingAnnotations = [[NSMutableArray alloc] init];
    for (id annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[BMStop class]])
        {
            BMStop *stop = (BMStop *)annotation;
            [existingAnnotations addObject:stop.identifier];
        }
    }
    for (NSDictionary *stopData in apiData[@"data"][@"list"]) {
        if (! [existingAnnotations containsObject:stopData[@"code"]]) {
            BMStop *annotation = [[BMStop alloc] initWithStopData:stopData];
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
    NSLog(@"annotation: %@", annotation);
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    if([annotation isKindOfClass:[BMStop class]]){
        BMStop *stop = (BMStop *)annotation;
        NSString *annotationViewID = [NSString stringWithFormat:@"StopAnnotationView%@", stop.identifier];
        
        MKAnnotationView *customPinView = [theMapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
        
        if (! customPinView) {
            NSLog(@"Did not deque. New type of pin: %@", annotationViewID);
            customPinView = [[BMStopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
            [customPinView setCanShowCallout:YES];
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            double hue = [BIHelpers hueForStop:[stop.identifier intValue]];
            rightButton.tintColor = [UIColor colorWithHue:hue saturation:1 brightness:0.7 alpha:1];
            customPinView.rightCalloutAccessoryView = rightButton;
        }
        else {
            NSLog(@"Did deque.");
        }
        
        return customPinView;
    }
    
    return nil;
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view isKindOfClass:[BMStopAnnotationView class]]) {
        BNNearbyViewController *parent = (BNNearbyViewController *)[self parentViewController];
        BMStop *stop = (BMStop *)view.annotation;
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

- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self zoomToFitAnnotations];
    return ;
    // zoom into users location once
    static BOOL didZoomIn = FALSE;
    if (!didZoomIn) {
        didZoomIn = TRUE;
        CLLocationAccuracy accuracy = userLocation.location.horizontalAccuracy;
        if (accuracy > 0) {
            MKCoordinateRegion mapRegion;
            mapRegion.center = map.userLocation.coordinate;
            mapRegion.span.latitudeDelta = 0.015;
            mapRegion.span.longitudeDelta = 0.015;
            [map setRegion:mapRegion animated: YES];
        }
    }
}


@end
