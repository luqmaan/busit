//
//  BMViewController.m
//  BusStop
//
//  Created by Lolcat on 18/05/2013.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BMViewController.h"

@interface BMViewController () {
    NSDictionary *apiData;
    BIRest *bench;
    BMRoutes *routes;
    NSString *agencyId;
    BMOptions *mapOptions;
    NSTimer *updateTimer;
    BOOL updateInProgress;
    BOOL firstTimeAddingVehiclesToRoutes;
}

@property (nonatomic, retain) BIRest *bench;
@property (nonatomic, retain) NSDictionary *apiData;

@end

@implementation BMViewController

@synthesize apiData, bench, mapView, statusView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {        
        bench = [[BIRest alloc] init];
        apiData = [[NSDictionary alloc]init];
        agencyId = @"Hillsborough Area Regional Transit";
        mapOptions = [[BMOptions alloc] init];
        routes = [[BMRoutes alloc] init];
        updateInProgress = FALSE;
        firstTimeAddingVehiclesToRoutes = TRUE;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [BIHelpers drawCornersAroundView:self.view];
    [self initMap];
    [self updateMap];
    [self zoomIntoTampa];
    self.navBar.topItem.prompt = @"Updating";
}

#pragma mark - Map & Location

- (void)initMap
{
    mapView.delegate = self;
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
};

- (void)zoomIntoTampa
{
    [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 27.977727;
    zoomLocation.longitude = -82.454109;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10.5*METERS_PER_MILE, 10.5*METERS_PER_MILE);
    [mapView setRegion:viewRegion animated:YES];
}
//
//- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    CLLocationAccuracy accuracy = userLocation.location.horizontalAccuracy;
//    if (accuracy > 0) {
//        MKCoordinateRegion mapRegion;
//        mapRegion.center = map.userLocation.coordinate;
//        mapRegion.span.latitudeDelta = 0.2;
//        mapRegion.span.longitudeDelta = 0.2;
//        [map setRegion:mapRegion animated: YES];
//    }
//}

- (void)updateMap
{
    if (updateInProgress) {
        NSLog(@"Attempted to run a new update while update is in progress.");
        return;
    }
    
    dispatch_queue_t fetchAPIData = dispatch_queue_create("com.awesomeness.I.am", DISPATCH_QUEUE_SERIAL);

    dispatch_async(fetchAPIData, ^{
        updateInProgress = TRUE;
        [self stopTimer];
        [self updateAPIData];
        NSLog(@"updateRoutes");
        [self updateRoutes];
        NSLog(@"addVehiclesToRoutes");
        [self addVehiclesToRoutes];
        [self startTimer];
        updateInProgress = FALSE;
    });
}

#pragma mark - API

- (void)updateAPIData
{
    apiData = [bench vehiclesForAgency:agencyId];
}

- (void)updateRoutes
{
    for (NSDictionary *routesDict in apiData[@"data"][@"references"][@"routes"]) {
        [routes addRouteWithRoutesDict:routesDict];
        [mapOptions addRouteWithRoutesDict:routesDict];
    }
}

- (void)addVehiclesToRoutes {
    
    for (NSDictionary *vehicleDict in apiData[@"data"][@"list"]) {
        if (vehicleDict[@"tripStatus"] == nil || [vehicleDict[@"tripId"] isEqual: @""])
        {
//            NSLog(@"discard");
            continue;
        }
        BMVehicle *vehicle = [[BMVehicle alloc] initWithJSON:vehicleDict
                                                      andAPIData:&apiData];
        
        // another method (to be implemented later) will call removeAnnotations
        // for routes that should no longer be visible (based on mapOptions)

        if (!firstTimeAddingVehiclesToRoutes && [routes hasVehicle:vehicle]) {
//            NSLog(@"Updating vehicle: %@", vehicle);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [routes updateVehicle:vehicle];
            });
        }
        else {
//            NSLog(@"New vehicle: %@", vehicle);
            [routes addVehicle:vehicle];
            // if the annotation is not yet on the map (and its route is visible),
            // add it to the map
            if ([mapOptions isVisibleRoute:vehicle.routeId]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [mapView addAnnotation:vehicle];
                });
            }
        }
            
    }
    
    firstTimeAddingVehiclesToRoutes = FALSE;
//    NSLog(@"routes: %@", routes);
}

-(IBAction)refreshBtnPress:(id)sender
{
    [self updateMap];
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    if([annotation isKindOfClass:[BMVehicle class]]){

        BMVehicle *vehicle = (BMVehicle *)annotation;
        NSString *annotationViewID = [NSString stringWithFormat:@"busPin%@", vehicle.routeShortName];
        
        MKAnnotationView *customPinView = [theMapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
        if (! customPinView) {
            NSLog(@"Did not deque. New type of pin: %@", annotationViewID);
            customPinView = [[BMVehicleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
            
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

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.5
                         animations:^{ annView.frame =  endFrame; }];
    }
}

- (void)startTimer
{
    NSLog(@"Started timer");
    updateTimer = [NSTimer timerWithTimeInterval:10.0
                                         target:self
                                       selector:@selector(updateMap)
                                       userInfo:nil
                                        repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer
{
    [updateTimer invalidate];
    updateTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // Remove routes?
}

- (void)viewDidUnload {
    [self stopTimer];
    [super viewDidUnload];
}
@end
