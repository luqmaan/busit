//
//  RouteStopsViewController.h
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Route.h"
#import "Stop.h"

@interface RouteStopsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
    CLLocation *newLocation;
    NSInteger currentIndex;
    CLLocationManager *mgr;
}

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceFromHereLabel;
@property (nonatomic, weak) IBOutlet MKMapView *stopMap;
@property (nonatomic, weak) IBOutlet UITableView *stopsTable;

@property (nonatomic, strong) Route *currentRoute;
@property (nonatomic, strong) NSArray *stops;
@property (nonatomic, strong) NSMutableArray *distances;

-(void)locationChanged:(NSNotification *)note;

@end
