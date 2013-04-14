//
//  SearchDestinationViewController.m
//  BusStop
//
//  Created by Adam Lowther on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "SearchDestinationViewController.h"
#import "DestinationAnnotation.h"
#import "DestinationAnnotationView.h"
#import "SearchStartingViewController.h"

@interface SearchDestinationViewController ()
@property (nonatomic, strong) CLPlacemark *placemarkToPass;
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
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBarForAddress resignFirstResponder];
    CLGeocoder *geocodeAddressFromSearchBar = [[CLGeocoder alloc] init];
    [geocodeAddressFromSearchBar geocodeAddressString:[self.searchBarForAddress text] completionHandler:^(NSArray *placemarks, NSError *error)         {
        NSLog(@"geocodeAddressString:inRegion:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:[error localizedDescription]];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        [self displayPlacemarks:placemarks];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"Entered viewForAnnotation");
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    if([annotation isKindOfClass:[DestinationAnnotation class]]){
        static NSString *AnnotationViewID = @"annotationViewID";
        DestinationAnnotationView *customPinView = [[DestinationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        [customPinView setCanShowCallout:YES];
        
        customPinView.opaque = NO;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        customPinView.rightCalloutAccessoryView = rightButton;
        return customPinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self performSegueWithIdentifier:@"toStartingPoint" sender:view];
}

-(void)displayPlacemarks:(NSArray *)arrayOfPlacemarks {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.placemarkToPass = [arrayOfPlacemarks objectAtIndex:0];
        NSLog(@"%@", self.placemarkToPass);
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.placemarkToPass.location.coordinate.latitude, self.placemarkToPass.location.coordinate.longitude);
        NSDictionary *areaOfInterest = [NSDictionary dictionaryWithDictionary:self.placemarkToPass.addressDictionary];
        NSString *addressSubtitle = [NSString stringWithFormat:@"%@, %@ %@", [areaOfInterest objectForKey:@"Street"], [areaOfInterest objectForKey:@"City"], self.placemarkToPass.administrativeArea];
        DestinationAnnotation *annotation = [[DestinationAnnotation alloc] initWithTitle:addressSubtitle andSubtitle:@"Click to advance"];
        [annotation setAlertLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
        [annotation setAlertLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
        [self.mapToDisplayAddressFromSearchBar setCenterCoordinate:coordinate];
        [self.mapToDisplayAddressFromSearchBar addAnnotation:annotation];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SearchStartingViewController *destinationViewController = [segue destinationViewController];
    [destinationViewController setPlacemarkFromDestination:[NSArray arrayWithObject:self.placemarkToPass]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
