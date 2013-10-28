//
//  BIRouteDetailsViewController.m
//  BusIt
//
//  Created by Lolcat on 9/29/13.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "BIRouteDetailsViewController.h"

@interface BIRouteDetailsViewController () {
    NSArray *searchResults;
}

@end

@implementation BIRouteDetailsViewController

@synthesize route;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
    self.navigationItem.title = route.routeLongName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // TODO: Can dispose of and recreate the route.stops
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;

    } else {
        return [route.stops count];
    }
}

- (BIStop *)dataForIndexPath:(NSIndexPath *)path
{
    return route.stops[path.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StopCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    UILabel *stopId = (UILabel *)[cell viewWithTag:1];
    UILabel *stopName = (UILabel *)[cell viewWithTag:2];
    UILabel *distance = (UILabel *)[cell viewWithTag:3];

    BIStop *stop;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        stop = [searchResults objectAtIndex:indexPath.row];
    }
    else {
        stop = [self dataForIndexPath:indexPath];
    }

    stopId.text = [stop.code stringValue];
    stopName.text = stop.name;

    distance.text = [NSString stringWithFormat:@"%.01fmi", [stop.distance floatValue]];

    return cell;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StopDetailsSegue"])
    {
        NSLog(@"StopDetailsSegue");
        BIStopDetailsViewController *stopDetailsVC = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        stopDetailsVC.stop = [self dataForIndexPath:path];
    }
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSString *searchPredicate = [NSString stringWithFormat:@"name CONTAINS[c] \"%@\"", searchText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:searchPredicate];
    searchResults = [route.stops filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];

    return YES;
}

@end
