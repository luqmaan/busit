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

@synthesize mapView, userLocation, btnUserLocation, btnSearch, searchBar, btnBookmark;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        // For some reason mapView is null here, so I set the mapView's properties in the viewDidLoad method
    }
    return self;
}

- (void)addStopsToMap:(NSArray *)stops
{
    [self removeAnnotations:mapView.annotations];
    
    // Add the stops with new identifiers.
    for (BDStop *stop in stops) {
        BMStopAnnotation *annotation = [[BMStopAnnotation alloc] initWithStop:stop];
        [mapView addAnnotation:annotation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    btnUserLocation.layer.cornerRadius = 5.0f;
    btnSearch.layer.cornerRadius = 5.0f;
    btnBookmark.layer.cornerRadius = 5.0f;
    [self setupSearchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)removeAnnotations:(NSArray *)annotations
{
    for (id<MKAnnotation>annotation in annotations) {
        if([annotation isKindOfClass:[MKUserLocation class]])
            continue;
        MKAnnotationView *annotationView = [mapView viewForAnnotation:annotation];
        [UIView animateWithDuration:0.5f animations:^(void){
            annotationView.alpha = 0.0f;
        }
         completion:^(BOOL finished){
             [mapView removeAnnotation:annotation];
         }];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
 
    if([aV.annotation isKindOfClass:[MKUserLocation class]])
        return;
        
    for (aV in views) {
        aV.alpha = 0.0f;
        [UIView beginAnimations:nil context:NULL];
        aV.alpha = 1.0f;
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView commitAnimations];
        
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
    
    NSLog(@"did Update user location");
    
    if (!didZoomIn) {
        didZoomIn = TRUE;
        [self zoomToUserLocation:nil];
    }
}

- (IBAction)zoomToUserLocation:(id)sender {
    NSLog(@"Did press zoom to user location button");
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.0075;
    mapRegion.span.longitudeDelta = 0.0075;
    [mapView setRegion:mapRegion animated:YES];
//    self.didUpdateLocationBlock();
//    NSLog(@"didUpdateLocationBlock %@", self.didUpdateLocationBlock);
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.didUpdateLocationBlock();
}

#pragma mark - Search bar

- (void)setupSearchBar
{
    searchBar.delegate = self;
}

- (void)hideSearchBarProperly
{
    CGRect newFrame = searchBar.frame;
    newFrame.origin.y = searchBar.frame.size.height * -1;
    searchBar.frame = newFrame;
    searchBar.hidden = NO;
}

- (IBAction)showSearchBar:(id)sender {
    NSLog(@"Did press search bar button");
    // Use the initial frame of the search bar to begin with.
    // Then move it just outside of the screen.
    // Perform a slide-in animation by transitioning to the new frame.
    CGRect newFrame = searchBar.frame;
    newFrame.origin.y = 0;
    [self hideSearchBarProperly];
    [UIView animateWithDuration:0.2f animations:^(void){
        searchBar.frame = newFrame;
    } completion:nil];
    
}

- (void)dismissSearchBar {
    CGRect newFrame = searchBar.frame;
    newFrame.origin.y = searchBar.frame.size.height * -1;
    [UIView animateWithDuration:0.2f animations:^(void){
        searchBar.frame = newFrame;
    } completion:nil];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
    [searchBar resignFirstResponder];
    [self dismissSearchBar];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    // hide the keyboard
    [searchBar resignFirstResponder];
    // http://stackoverflow.com/questions/2281798/how-to-search-mkmapview-with-uisearchbar
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"%@", placemarks);
        
        if (placemark) {
            MKCoordinateRegion region;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span = mapView.region.span;
            
            // update the mapview and hide  the search bar
            [mapView setRegion:region animated:YES];
        }
        else {
            // TODO: Find a way to notify the user that the location couldn't be found.
            NSLog(@"Could not find a matching location");
        }
        [self dismissSearchBar];
    }];
}




@end
