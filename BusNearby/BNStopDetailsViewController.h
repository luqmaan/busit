//
//  BNStopDetailsViewController.h
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStopREST.h"
#import "BNArrivalDeparturesTableViewController.h"

@interface BNStopDetailsViewController : UIViewController

@property (weak, nonatomic) NSDictionary *stopData;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *stopIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UIView *arrivalsDeparturesTableView;


@end
