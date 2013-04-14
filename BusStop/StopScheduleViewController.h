//
//  StopScheduleViewController.h
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stop.h"

@interface StopScheduleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Stop *busStop;
@property (nonatomic, strong) NSString *currentRouteId;

@property (nonatomic, strong) NSMutableDictionary *allEntries;
@property (nonatomic, strong) NSMutableArray *visibleEntries;

@property (nonatomic, weak) IBOutlet UILabel *stopNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UITableView *slotsTable;

-(IBAction)routerFilterTapped:(id)sender;

@end
