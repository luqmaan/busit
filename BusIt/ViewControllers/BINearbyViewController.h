//
//  BINearbyViewController.h
//  BusStop
//
//  Created by Lolcat on 8/3/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BIHelpers.h"
#import "BIStopDetailsViewController.h"
#import "BMEmbeddedMapViewController.h"
#import "BIBusData.h"
#import "BIStop.h"

@interface BINearbyViewController : UITableViewController  <CLLocationManagerDelegate>

- (IBAction)refreshBtnPress:(id)sender;
- (void)performSegueForMapViewWithStop:(NSString *)stopCode;

@end
