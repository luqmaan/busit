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
#import "BITrip.h"
#import "BIStopDetailsViewController.h"
#import "BMRouteMapViewController.h"

@interface BIRouteDetailsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property BIRoute *route;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)showSearchBar:(id)sender;

@end
