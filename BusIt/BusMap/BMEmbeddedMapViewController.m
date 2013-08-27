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

- (void)initWithStops:(NSDictionary *)apiData
{
    [self initMapView];
    for (NSDictionary *stopData in apiData[@"data"][@"list"]) {
        BMStop *annotation = [[BMStop alloc] initWithStopData:stopData];
        [mapView addAnnotation:annotation];
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
            customPinView.rightCalloutAccessoryView = rightButton;
        }
        else {
            NSLog(@"Did deque.");
        }
        
        return customPinView;
    }
    
    return nil;
    
}

- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)userLocation
{
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view isKindOfClass:[BMStopAnnotationView class]]) {
        BNNearbyViewController *parent = (BNNearbyViewController *)[self parentViewController];
        BMStop *stop = (BMStop *)view.annotation;
        [parent performSegueForMapViewWithStop:stop.identifier];
    }
}

@end
