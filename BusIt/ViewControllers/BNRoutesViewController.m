//
//  BNRoutesViewController.m
//  BusIt
//
//  Created by Lolcat on 9/26/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BNRoutesViewController.h"

@interface BNRoutesViewController ()

@property BDBusData *busData;
@property NSArray *routes;

@end

@implementation BNRoutesViewController

@synthesize busData, routes;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        busData = [[BDBusData alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    routes = [busData routes];
    [self.tableView reloadData];
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

- (BDRoute *)dataForIndexPath:(NSIndexPath *)indexPath
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
    
    BDRoute *route = [self dataForIndexPath:indexPath];
  
    UIColor *routeColor = [UIColor colorWithHue:route.hue saturation:1 brightness:0.7 alpha:1];

    routeName.text = route.routeLongName;
    routeNumber.text = route.routeShortName;
    routeNumber.backgroundColor = [UIColor clearColor];
    
    routeNumber.layer.cornerRadius = 5.0f;
    routeNumber.layer.borderWidth = 1.0f;
    routeNumber.layer.borderColor = routeColor.CGColor;
    routeNumber.textColor = routeColor;
    
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
        BNRouteDetailsViewController *routeDetailsVC = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        routeDetailsVC.route = [self dataForIndexPath:path];
    }
}

@end
