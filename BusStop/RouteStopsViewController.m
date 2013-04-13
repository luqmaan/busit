//
//  RouteStopsViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BusStopAppDelegate.h"
#import "RouteStopsViewController.h"
#import "StopCell.h"

@interface RouteStopsViewController ()

@end

@implementation RouteStopsViewController

-(void)recomputeDistances
{
    if(nil != newLocation)
    {
        int i=0;
        for( Stop *stop in self.stops )
        {
            CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:[stop.lat doubleValue] longitude:[stop.lon doubleValue]];
            double distanceInMeters = [stopLocation distanceFromLocation:newLocation];
            double distanceInMiles = distanceInMeters*0.000621371;
            self.distances[i++] = @(distanceInMiles);
        }
    }
}

-(void)locationChanged:(NSNotification *)note
{
    BusStopAppDelegate *delegate = (BusStopAppDelegate *)note.object;
    newLocation = delegate.mgr.location;
    [self recomputeDistances];
    [self.stopsTable reloadData];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
    self.stops = [[self.currentRoute.stops allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Stop *stop1 = (Stop *)obj1;
        Stop *stop2 = (Stop *)obj2;
        if(stop1.code > stop2.code)
            return NSOrderedDescending;
        else
        if(stop1.code < stop2.code)
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    
    BusStopAppDelegate *app = (BusStopAppDelegate *)[[UIApplication sharedApplication] delegate];
    newLocation = app.mgr.location;
    
    self.distances = [[NSMutableArray alloc] initWithCapacity:self.stops.count];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:kLocationUpdated object:nil];
    [self recomputeDistances];
    [self.stopsTable reloadData];
}

-(void)didReceiveMemoryWarning
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
    NSInteger numRows = self.stops.count;
    return numRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StopCell *cell = (StopCell *)[tableView dequeueReusableCellWithIdentifier:@"StopCell"];
    if(nil == cell)
        cell = [[StopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StopCell"];
    
    Stop *busStop = self.stops[indexPath.row];
    cell.stopNameLabel.text = busStop.name;
    cell.stopDirectionLabel.text = busStop.direction;
    double distanceAwayInMiles = [self.distances[indexPath.row] doubleValue];
    if(distanceAwayInMiles<.10)
    {
        double distanceAwayInFeet = distanceAwayInMiles * 5280.0;
        cell.stopDistanceLabel.text = @"1.5 miles";
    }
    else
    if(distanceAwayInMiles<10.0)
    {
        cell.stopDistanceLabel.text = [NSString stringWithFormat:@"%.1f miles", distanceAwayInMiles];
    }
    else
    {
        cell.stopDistanceLabel.text = [NSString stringWithFormat:@"%.0f miles", distanceAwayInMiles];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
