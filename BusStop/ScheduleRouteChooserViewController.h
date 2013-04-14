//
//  ScheduleRouteViewController.h
//  BusStop
//
//  Created by Chris Woodard on 4/14/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleRouteChooserViewController.h"

@protocol ScheduleRouteChooserDelegate <NSObject>
-(void)didSelectRouteWithId:(NSString *)routeId;
@end

@interface ScheduleRouteChooserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *routes;
@property (nonatomic, strong) NSArray *routeKeys;
@property (nonatomic, weak) id<ScheduleRouteChooserDelegate> delegate;
@property (nonatomic, assign) NSString *currentKey;

-(IBAction)cancel:(id)sender;
-(IBAction)done:(id)sender;

@end
