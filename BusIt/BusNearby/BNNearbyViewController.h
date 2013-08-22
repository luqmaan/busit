//
//  BNNearbyViewController.h
//  BusStop
//
//  Created by Lolcat on 8/3/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BIHelpers.h"
#import "BIRest.h"
#import "BNArrivalsTableViewController.h"

@interface BNNearbyViewController : UITableViewController  <CLLocationManagerDelegate>

- (IBAction)refreshBtnPress:(id)sender;

@end
