//
//  SearchDestinationViewController.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "SearchDestinationViewController.h"

@interface SearchDestinationViewController ()

@end

@implementation SearchDestinationViewController

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
    [self.searchBarForAddress setDelegate:self];
    [self.searchBarForAddress setAutocorrectionType:UITextAutocorrectionTypeNo];
    
	// Do any additional setup after loading the view.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    CLGeocoder *geocodeAddressFromSearchBar = nil;
    [geocodeAddressFromSearchBar geocodeAddressString:[self.searchBarForAddress text] completionHandler:^(NSArray *placemarks, NSError *error)         {
        NSLog(@"geocodeAddressString:inRegion:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:[error localizedDescription]];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        //[self displayPlacemarks:placemarks];
    }];
}

-(CLLocationCoordinate2D *)geocodeTranslation:(NSString *)stringFromSearchBar inRegion:(CLRegion *)currentRegion {
    CLLocationCoordinate2D *returnObject = nil;
    
    CLGeocoder *geocodeAddressFromSearchBar = nil;
    [geocodeAddressFromSearchBar geocodeAddressString:stringFromSearchBar completionHandler:^(NSArray *placemarks, NSError *error)         {
        NSLog(@"geocodeAddressString:inRegion:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:[error localizedDescription]];
            return;
        }
        
        NSLog(@"Received placemarks: %@", placemarks);
        //[self displayPlacemarks:placemarks];
    }];
    return returnObject;
}

-(void)displayError:(NSString *)errorMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)showHUD:(NSString *)hudMsg
{
    if(nil == hud)
    {
        hud = [[MBProgressHUD alloc] init];
        hud.labelText = hudMsg;
        [self.view addSubview:hud];
        [hud show:YES];
    }
}

-(void)updateHUD:(NSString *)hudMsg
{
    hud.labelText = hudMsg;
}

-(void)hideHUD
{
    [hud hide:YES];
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
    
    [self.mapToDisplayAddressFromSearchBar setShowsUserLocation:YES];
    [self.mapToDisplayAddressFromSearchBar setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
