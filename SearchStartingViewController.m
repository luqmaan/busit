//
//  SearchStartingViewController.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "SearchStartingViewController.h"

@interface SearchStartingViewController ()

@end

@implementation SearchStartingViewController

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
    [self setInitialMapZoom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    CLGeocoder *geocodeAddressFromSearchBar = [[CLGeocoder alloc] init];
    [geocodeAddressFromSearchBar geocodeAddressString:[self.searchBar text] completionHandler:^(NSArray *placemarks, NSError *error)         {
        NSLog(@"geocodeAddressString:inRegion:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            //[self displayError:[error localizedDescription]];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        //[self displayPlacemarks:placemarks];
    }];
}

-(void)setInitialMapZoom{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocation *newLocation = [locationManager location];
    double miles = 5.0;
    double scalingFactor = ABS( (cos(2 * M_PI * newLocation.coordinate.latitude / 360.0) ));
    
    MKCoordinateSpan span;
    
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = newLocation.coordinate;
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setRegion:region animated:YES];
}

@end
