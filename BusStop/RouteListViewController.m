//
//  RouteListViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "RouteListViewController.h"
#import "RouteStopsViewController.h"
#import "RouteCell.h"
#import "BusStopManager.h"

@interface RouteListViewController ()

@end

@implementation RouteListViewController

-(IBAction)refresh:(id)sender
{
    NSLog(@"refresh");
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
    self.routes = [[BusStopManager sharedManagerWithOnDiskStore] routes];
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
    NSInteger numRoutes = self.routes.count;
    return numRoutes;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Route *route = self.routes[indexPath.row];
    RouteCell *cell = (RouteCell *)[tableView dequeueReusableCellWithIdentifier:@"RouteCell"];
    if(nil == cell)
        cell = (RouteCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RouteCell"];
    NSInteger numStops = route.stops.count;
    cell.routeNameLabel.text = route.name;
    cell.routeDetailsLabel.text = [NSString stringWithFormat:@"%d stops", numStops];
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueId = [segue identifier];
    if([@"showRouteStops" isEqualToString: segueId])
    {
        // which row was this?
        RouteCell *rc = (RouteCell *)sender;
        UITableView *tbl = (UITableView *)rc.superview;
        NSIndexPath *ipx = [tbl indexPathForCell:rc];
        
        RouteStopsViewController *routesVC = (RouteStopsViewController *)[segue destinationViewController];
        routesVC.currentRoute = self.routes[ipx.row];
    }
}

@end
