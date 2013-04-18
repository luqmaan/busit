//
//  MapWebViewController.m
//  BusStop
//
//  Created by Robert Ries on 4/14/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "MapWebViewController.h"

@interface MapWebViewController ()

@end

@implementation MapWebViewController

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
    
    BusItem *bus6 = [[BusItem alloc] initWithCoordinate:zoomLocation routeName:@"Bus 6"];
    BusItem *bus4 = [[BusItem alloc] initWithCoordinate:aLocation routeName:@"Bus 4"];
    NSArray *buses = [NSArray arrayWithObjects:bus6, bus4, nil];

    CLLocationCoordinate2D moveLocation;
    moveLocation.latitude = 27.87;
    moveLocation.longitude = -82.394109;

    NSLog(@"about to add bus6 to view");
    [mapView addAnnotations:buses];

    NSLog(@"about to animate");
    [UIView animateWithDuration:1.2 animations:^{
        NSLog(@"inside of block");
        [bus4 setCoordinate:moveLocation];
        NSLog(@"called SetCoordinate");
    }];
    
    
    NSLog(@"%@", mapView);
    
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

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    NSLog(@"called viewForAnnotation");
    
    BusAnnotationView *annotationView = (BusAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    NSLog(@"annotationView: %@", annotationView);
    if (annotationView == nil)
    {
        NSLog(@"Brand new annotation!");
        annotationView = [[BusAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        NSLog(@"Allocated space for the new annotation!");
    }
    
    annotationView.annotation = annotation;

    NSLog(@"Done with the annotations!");
    
    return annotationView;
}


@end
