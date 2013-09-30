//
//  BDRouteDetailsViewController.h
//  BusIt
//
//  Created by Lolcat on 9/29/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBusData.h"
#import "BDRoute.h"

@interface BNRouteDetailsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property BDRoute *route;

@end
