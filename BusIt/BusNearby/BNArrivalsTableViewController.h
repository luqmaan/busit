//
//  BNArrivalDeparturesTableViewController.h
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BIRest.h"
#import "BIHelpers.h"

@interface BNArrivalsTableViewController : UITableViewController

@property (weak, nonatomic) NSDictionary *stopData;

- (IBAction)dismissView:(id)sender;
- (IBAction)refresh:(id)sender;

@end
