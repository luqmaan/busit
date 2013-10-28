//
//  BIArrivalDeparturesTableViewController.h
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BIHelpers.h"
#import "BIStop.h"

@interface BIStopDetailsViewController : UITableViewController

@property (weak, nonatomic) BIStop *stop;

- (IBAction)refresh:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
