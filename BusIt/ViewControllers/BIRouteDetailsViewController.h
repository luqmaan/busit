//
//  BIRouteDetailsViewController.h
//  BusIt
//
//  Created by Lolcat on 9/29/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIBusData.h"
#import "BIRoute.h"
#import "BIStopDetailsViewController.h"

@interface BIRouteDetailsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property BIRoute *route;

@end
