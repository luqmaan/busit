//
//  BIRoutesViewController.m
//  BusIt
//
//  Created by Lolcat on 9/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BIRoutesViewController.h"

@interface BIRoutesViewController ()

@property BIBusData *busData;
@property NSArray *routes;

@end

@implementation BIRoutesViewController

@synthesize busData, routes;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        busData = [[BIBusData alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    routes = [busData routes];
    [self.tableView reloadData];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHue:0.589 saturation:1 brightness:1.0 alpha:0.3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [routes count];
}

- (BIRoute *)dataForIndexPath:(NSIndexPath *)indexPath
{
    return routes[indexPath.row];
}

#pragma mark - Segues & Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RouteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    UILabel *routeNumber = (UILabel *)[cell viewWithTag:1];
    UILabel *routeName = (UILabel *)[cell viewWithTag:2];

    BIRoute *route = [self dataForIndexPath:indexPath];

    routeName.text = route.routeLongName;
    routeNumber.text = route.routeShortName;
    routeNumber.backgroundColor = [UIColor clearColor];

    routeNumber.layer.cornerRadius = 5.0f;
    routeNumber.layer.borderWidth = 1.0f;
    routeNumber.layer.borderColor = route.routeColor.CGColor;
    routeNumber.textColor = route.routeColor;

    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RouteDetailsSegue"]) {
        NSLog(@"RouteDetailsSegue");
        BIRouteDetailsViewController *routeDetailsVC = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        routeDetailsVC.route = [self dataForIndexPath:path];
    }
}

@end
