//
//  BNArrivalDeparturesTableViewController.h
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BIRest.h"
#import "BIHelpers.h"
#import "BDStop.h"

@interface BNArrivalsTableViewController : UITableViewController

@property (weak, nonatomic) NSDictionary *stop;

- (IBAction)dismissView:(id)sender;
- (IBAction)refresh:(id)sender;

@end
