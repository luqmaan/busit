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
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *toolBarMessage;

@end

@implementation BMViewController

@synthesize apiData, bench, mapView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMap];
    [self updateMap];
    [self zoomIntoTampa];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Perhaps remove routes?
}

- (void)viewDidUnload {
    [self stopTimer];
    [super viewDidUnload];
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

/*
 Should the map zoom to the users location?
- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationAccuracy accuracy = userLocation.location.horizontalAccuracy;
    if (accuracy > 0) {
        MKCoordinateRegion mapRegion;
        mapRegion.center = map.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.2;
        mapRegion.span.longitudeDelta = 0.2;
        [map setRegion:mapRegion animated: YES];
    }
}
*/

- (void)updateMap
{
    if (updateInProgress) {
        NSLog(@"Attempted to run a new update while update is in progress.");
        return;
    }

    dispatch_queue_t fetchAPIData = dispatch_queue_create("com.busit.vehiclesForRoute", DISPATCH_QUEUE_SERIAL);
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
    __weak BMViewController *self_ = self;
    self.progressBar.hidden = NO;
    bench.progressUpdateBlock = ^(float downloadProgress) {
        self_.progressBar.progress = downloadProgress;
        NSLog(@"downloadProgress: %f", downloadProgress);
    };
    apiData = [bench vehiclesForAgency:agencyId];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressBar.hidden = YES;
        self.progressBar.progress = 0;
    });
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
            continue;

        BMVehicle *vehicle = [[BMVehicle alloc] initWithJSON:vehicleDict
                                                  andAPIData:&apiData];
        // TODO: Add another method that will call removeAnnotations
        // for routes that should no longer be visible (based on mapOptions)
        if (!firstTimeAddingVehiclesToRoutes && [routes hasVehicle:vehicle]) {
            // updating vehicle
            dispatch_sync(dispatch_get_main_queue(), ^{
                [routes updateVehicle:vehicle];
            });
        }
        else {
            // adding new vehicle
            [routes addVehicle:vehicle];
            // if the annotation is not yet on the map (and its route is visible), add it to the map
            if ([mapOptions isVisibleRoute:vehicle.routeId]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [mapView addAnnotation:vehicle];
                });
            }
        }
    }
    firstTimeAddingVehiclesToRoutes = FALSE;
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
            customPinView = [[BMVehicleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];

            [customPinView setCanShowCallout:YES];

            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
        }
        else {
        }

        return customPinView;
    }

    return nil;

}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
{
    // drop from top of screen animation
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.5
                         animations:^{ annView.frame =  endFrame; }];
    }
}

#pragma mark - Timer

- (void)startTimer
{
    NSLog(@"Started timer");
    updateTimer = [NSTimer timerWithTimeInterval:1.0
                                          target:self
                                        selector:@selector(updateToolbarMessage)
                                        userInfo:nil
                                         repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer
{
    [updateTimer invalidate];
    updateTimer = nil;
}

int timeToUpdate = 10;
- (void)updateToolbarMessage
{
    self.toolBarMessage.text = [NSString stringWithFormat:@"Refreshing realtime bus locations in %d seconds", timeToUpdate];
    if (timeToUpdate == 0) {
        timeToUpdate = 10;
        [self stopTimer];
        self.toolBarMessage.text = @"Updating realtime bus locations";
        [self updateMap];
    }
    else {
        timeToUpdate -= 1;
    }
}

@end
