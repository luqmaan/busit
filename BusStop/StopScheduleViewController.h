//
//  StopScheduleViewController.h
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleRouteChooserViewController.h"
#import "Stop.h"

@interface StopScheduleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ScheduleRouteChooserDelegate>

@property (nonatomic, strong) Stop *busStop;
@property (nonatomic, strong) NSString *currentRouteId;

@property (nonatomic, strong) NSMutableDictionary *allEntries;
@property (nonatomic, strong) NSMutableArray *visibleEntries;
@property (nonatomic, strong) NSMutableDictionary *routesForStop;

@property (nonatomic, weak) IBOutlet UILabel *stopNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UITableView *slotsTable;

-(void)didSelectRouteWithId:(NSString *)routeId;
-(IBAction)routerFilterTapped:(id)sender;

@end
