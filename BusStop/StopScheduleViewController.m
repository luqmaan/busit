//
//  StopScheduleViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "StopScheduleViewController.h"
#import "ScheduleRouteChooserViewController.h"
#import "FPPopoverController.h"
#import "ScheduleCell.h"
#import "MBProgressHUD.h"
#import "BusStopREST.h"

@interface StopScheduleViewController ()

@end

@implementation StopScheduleViewController

-(void)updateCurrentTime
{
    NSDate *rightNow = [NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:rightNow];
    
    NSString *aAMPM = @"AM";
    int ahr = [currentComponents hour];
    if(ahr>12)
    {
        ahr -= 12;
        aAMPM = @"PM";
    }
    
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%0d:%02d %@", ahr, [currentComponents minute], aAMPM];
}

-(void)updateTime:(NSTimer *)timer
{
    [self updateCurrentTime];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.visibleEntries = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.visibleEntries = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void)switchToSlotsForRoute:(NSString *)routeId
{
    self.currentRouteId = routeId;
    [self.visibleEntries removeAllObjects];
    
    for( NSString *storedRouteId in [self.allEntries allKeys])
    {
        if([routeId isEqualToString:storedRouteId])
        {
            for( NSString *tripHeadSign in self.allEntries[storedRouteId])
            {
                for( NSDictionary *slot in self.allEntries[storedRouteId][tripHeadSign])
                {
                    [self.visibleEntries addObject:@{@"tripHeadSign":tripHeadSign, @"arrives":slot[@"arrival"], @"departs":slot[@"departure"]}];
                }
            }
        }
    }
    
    [self.slotsTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateCurrentTime];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    
    self.stopNameLabel.text = self.busStop.name;
    
    self.allEntries = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSCalendar *calendar = [NSCalendar currentCalendar];
        
    BusStopREST *mgr = [[BusStopREST alloc] init];
    NSDictionary *stopSched = [mgr scheduleForStop:self.busStop.id];
    NSArray *stopRouteSchedules = stopSched[@"data"][@"entry"][@"stopRouteSchedules"];
    for( NSDictionary *row in stopRouteSchedules )
    {
        // row[@"routeId"]
        NSString *routeId = row[@"routeId"];
        
        NSArray *stopRouteDirectionSchedules = row[@"stopRouteDirectionSchedules"];
        NSMutableDictionary *trips = [[NSMutableDictionary alloc] initWithCapacity:0];
        for( NSDictionary *row2 in stopRouteDirectionSchedules )
        {// one per "trip" - tripId and tripHeadSign
            NSString *tripHeadSign = row2[@"tripHeadsign"];

            NSMutableArray *times = [[NSMutableArray alloc] initWithCapacity:0];            
            NSArray *scheduleStopTimes = row2[@"scheduleStopTimes"];
            for( NSDictionary *row3 in scheduleStopTimes )
            {
                NSNumber *arrivalTimeNbr = row3[@"arrivalTime"];
                NSNumber *departureTimeNbr = row3[@"departureTime"];
                NSDate *arrivalTime = [NSDate dateWithTimeIntervalSince1970:[arrivalTimeNbr doubleValue]/1000.0];
                NSDate *departureTime = [NSDate dateWithTimeIntervalSince1970:[departureTimeNbr doubleValue]/1000.0];
                 
                NSDateComponents *arrivalComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:arrivalTime];
                NSDateComponents *departureComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:departureTime];
                
                NSString *aAMPM = @"AM";
                int ahr = [arrivalComponents hour];
                if(ahr>12)
                {
                    ahr -= 12;
                    aAMPM = @"PM";
                }
                
                NSString *dAMPM = @"AM";
                int dhr = [departureComponents hour];
                if(dhr>12)
                {
                    dhr -= 12;
                    dAMPM = @"PM";
                }
                
                NSString *arrivalStr = [NSString stringWithFormat:@"arrives %0d:%02d %@", ahr, [arrivalComponents minute], aAMPM];
                NSString *departureStr = [NSString stringWithFormat:@"departs %0d:%02d %@", dhr, [departureComponents minute], dAMPM];
                
                [times addObject:@{@"arrival":arrivalStr, @"departure":departureStr}];
            }
            
            trips[tripHeadSign] = times;
        }
        
        self.allEntries[routeId] = trips;
    }
    
    if(stopRouteSchedules.count>0)
    {
        self.currentRouteId = stopRouteSchedules[0][@"routeId"];
        [self switchToSlotsForRoute:self.currentRouteId];
    }
}

-(void)didSelectRouteWithId:(NSString *)routeId
{
    [self switchToSlotsForRoute:routeId];
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
    NSInteger numEntries = self.visibleEntries.count;
    return numEntries;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = self.visibleEntries[indexPath.row];
    
    ScheduleCell *cell = (ScheduleCell *)[tableView dequeueReusableCellWithIdentifier:@"ScheduleCell"];
    if(nil == cell)
        cell = (ScheduleCell *)[[ScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScheduleCell"];
    
    cell.headSignLabel.text = row[@"tripHeadSign"];
    cell.arrivalLabel.text = row[@"arrives"];
    cell.departureLabel.text = row[@"departs"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"yeah");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ScheduleRouteChooserViewController *vc = (ScheduleRouteChooserViewController *)[segue destinationViewController];
    
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithCapacity:0];
    for( NSString *routeId in [self.allEntries allKeys])
    {
        d[routeId] = @YES;
    }
    
    vc.delegate = self;
    vc.currentKey = self.currentRouteId;
    vc.routes = d;
}

@end
