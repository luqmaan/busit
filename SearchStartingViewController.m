//
//  SearchStartingViewController.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "SearchStartingViewController.h"
#import "UserStartAnnotation.h"
#import "UserStartAnnotationView.h"

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
        [self displayPlacemarks:placemarks];
    }];
}

-(void)displayPlacemarks:(NSArray *)arrayOfPlacemarks {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.placemarkToPass = [arrayOfPlacemarks objectAtIndex:0];
        NSLog(@"%@", self.placemarkToPass);
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.placemarkToPass.location.coordinate.latitude, self.placemarkToPass.location.coordinate.longitude);
        NSDictionary *areaOfInterest = [NSDictionary dictionaryWithDictionary:self.placemarkToPass.addressDictionary];
        NSString *addressSubtitle = [NSString stringWithFormat:@"%@, %@ %@", [areaOfInterest objectForKey:@"Street"], [areaOfInterest objectForKey:@"City"], self.placemarkToPass.administrativeArea];
        UserStartAnnotation *annotation = [[UserStartAnnotation alloc] initWithTitle:addressSubtitle andSubtitle:@"Click Route"];
        [annotation setAlertLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
        [annotation setAlertLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
        [self.mapView setCenterCoordinate:coordinate];
        [self.mapView addAnnotation:annotation];
    });
}

-(void)displayError:(NSString *)errorMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
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
