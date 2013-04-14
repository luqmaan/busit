//
//  StopScheduleViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "StopScheduleViewController.h"
#import "MBProgressHUD.h"
#import "BusStopREST.h"

@interface StopScheduleViewController ()

@end

@implementation StopScheduleViewController

-(void)displaySlotsForRoute:(NSString *)routeId
{
}

-(IBAction)routerFilterTapped:(id)sender
{
    NSLog(@"filter routes");
    
#if 0
   //the view controller you want to present as popover
    YourViewController *controller = [[YourViewController alloc] init]; 

    //our popover
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller]; 

    //the popover will be presented from the okButton view 
    [popover presentPopoverFromView:okButton]; 
#endif

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    // now we have the bus stop id, and we can get scheduled stops from api
    //TODO - data structures we need: trips (routeId + trip head sign) keying NSDictionary holding stop info; keys are sections and get pulled into
    // popup, values are displayed in table cells.
    BusStopREST *mgr = [[BusStopREST alloc] init];
    NSDictionary *stopSched = [mgr scheduleForStop:self.busStop.id];
    NSArray *stopRouteSchedules = stopSched[@"data"][@"entry"][@"stopRouteSchedules"];
    for( NSDictionary *row in stopRouteSchedules )
    {
        // row[@"routeId"]
        NSArray *stopRouteDirectionSchedules = row[@"stopRouteDirectionSchedules"];
        for( NSDictionary *row2 in stopRouteDirectionSchedules )
        {// one per "trip" - tripId and tripHeadSign
            NSString *tripHeadSign = row2[@"tripHeadsign"];
            NSArray *scheduleStopTimes = row2[@"scheduleStopTimes"];
            NSLog(@"%@ %@;", row[@"routeId"], tripHeadSign);
            for( NSDictionary *row3 in scheduleStopTimes )
            {
                NSNumber *arrivalTimeNbr = row3[@"arrivalTime"];
                NSNumber *departureTimeNbr = row3[@"departureTime"];
                NSDate *arrivalTime = [NSDate dateWithTimeIntervalSince1970:[arrivalTimeNbr doubleValue]/1000.0];
                NSDate *departureTime = [NSDate dateWithTimeIntervalSince1970:[departureTimeNbr doubleValue]/1000.0];
                NSLog(@"arrives: %@", arrivalTime);
                NSLog(@"departs: %@", departureTime);
                //TODO - since we're only getting this for the same day, only extract and format the time and do it AM/PM format.
            }
        }
    }
    NSLog(@"argh");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
