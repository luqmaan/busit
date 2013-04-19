//
//  TripsMapViewController.m
//  BusStop
//
//  Created by Robert Ries on 4/14/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "TripsMapViewController.h"

@interface TripsMapViewController ()

@end

@implementation TripsMapViewController

@synthesize mapView;

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
    mapView.delegate = self;

    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];

//    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 27.977727;
    zoomLocation.longitude = -82.454109;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
                                                                       10*METERS_PER_MILE,
                                                                       10.*METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:YES];
    
    CLLocationCoordinate2D aLocation;
    aLocation.latitude = 28;
    aLocation.longitude = -82.464109;
    
//    BusItem *bus6 = [[BusItem alloc] initWithLatitude:[NSNumber numberWithDouble:zoomLocation.latitude]
//                                            Longitude:[NSNumber numberWithDouble:zoomLocation.longitude]
//                                                Route:@"Bus 6"
//                                         andName:@"Northbound"];
//    BusItem *bus5 = [[BusItem alloc] initWithLatitude:[NSNumber numberWithDouble:aLocation.latitude]
//                                            Longitude:[NSNumber numberWithDouble:aLocation.longitude]
//                                                Route:@"Bus 5"
//                                         andName:@"Southbound"];
//    NSArray *buses = [NSArray arrayWithObjects:bus6, bus5, nil];
//
//    CLLocationCoordinate2D moveLocation;
//    moveLocation.latitude = 27.87;
//    moveLocation.longitude = -82.394109;
//
//    NSLog(@"about to add bus6 to view");
//    [mapView addAnnotations:buses];
//    
//    NSLog(@"about to animate");
//    [UIView animateWithDuration:1.2 animations:^{
//        NSLog(@"inside of block");
//        [bus5 setCoordinate:moveLocation];
//        NSLog(@"called SetCoordinate");
//    }];
//
//    NSLog(@"%@", mapView);
    
    TripData *tripData = [[TripData alloc] init];
    NSArray *busItems = [tripData busItemsForRoute:@"Hillsborough Area Regional Transit_6"];
    
    
    NSLog(@"about to add annotations to map");
    [mapView addAnnotations:busItems];
    
    NSLog(@"Done did get busItemsArray");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}


@end
