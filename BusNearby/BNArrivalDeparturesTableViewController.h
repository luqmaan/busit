//
//  BNArrivalDeparturesTableViewController.h
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopREST.h"

@interface BNArrivalDeparturesTableViewController : UITableViewController

@property (weak, nonatomic) NSDictionary *stopData;

@end
