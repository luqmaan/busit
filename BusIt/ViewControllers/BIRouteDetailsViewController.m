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

@synthesize route, searchBar;

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
    self.navigationItem.title = [NSString stringWithFormat:@"Stops"];
    searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO: Can dispose of and recreate the route.stops, route.trips
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 1;
    else
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Search Results
    if (tableView == self.searchDisplayController.searchResultsTableView && searchResults)
        return [searchResults count];
    // Route Title
    if (section == 0)
        return 1;
    // Trips
    if (section == 1)
        return [route.trips count];
    // Stops
    return [route.stops count];
}

- (id)dataForIndexPath:(NSIndexPath *)path
{
    if (searchResults && [searchResults count] != 0) {
        return [searchResults objectAtIndex:path.row];
    } else {
        if (path.section == 1)
            return route.trips[path.row];
        else
            return route.stops[path.row];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    UITableViewCell *cell;
//    NSLog(@"cellForRowAtIndexPath section: %ld row: %ld. The number of rows in this section are: %ld", (long)indexPath.section, (long)indexPath.row, (long)[self tableView:tableView numberOfRowsInSection:indexPath.section]);
    
    if (indexPath.section == 2 || tableView == self.searchDisplayController.searchResultsTableView) {
        CellIdentifier = @"StopCell";
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        } else {
            cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
        
        UILabel *stopId = (UILabel *)[cell viewWithTag:1];
        UILabel *stopName = (UILabel *)[cell viewWithTag:2];
        UILabel *distance = (UILabel *)[cell viewWithTag:3];
        
        BIStop *stop = [self dataForIndexPath:indexPath];
        
        stopId.text = [stop.code stringValue];
        stopName.text = stop.name;
        distance.text = [NSString stringWithFormat:@"%.01fmi", [stop.distance floatValue]];
    }    
    else if (indexPath.section == 0) {
        CellIdentifier = @"RouteOverviewCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *routeName = (UILabel *)[cell viewWithTag:1];
        routeName.text = [NSString stringWithFormat:@"%@ %@", route.routeShortName, route.routeLongName];
    }
    else if (indexPath.section == 1) {
        CellIdentifier = @"TripCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *tripName = (UILabel *)[cell viewWithTag:1];
        UILabel *tripDirection = (UILabel *)[cell viewWithTag:1];
        BITrip *trip = [self dataForIndexPath:indexPath];
        tripName.text = trip.tripHeadsign;
        tripDirection.text = trip.direction;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 30;
    else if (indexPath.section == 0)
        return 50.0f;
    else
        return 30.0f;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StopDetailsSegue"])
    {
        NSLog(@"StopDetailsSegue");
        BIStopDetailsViewController *stopDetailsVC = segue.destinationViewController;
        NSIndexPath *path;
        if (searchResults) {
            path = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
        }
        else {
            path = [self.tableView indexPathForSelectedRow];
        }
        stopDetailsVC.stop = [self dataForIndexPath:path];
    }
    else if ([[segue identifier] isEqualToString:@"RouteMapSegue"]) {
        NSLog(@"RouteMapSegue");
        BMRouteMapViewController *routeMapViewVC = segue.destinationViewController;
        routeMapViewVC.route = route;
    }
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *searchPredicate = [NSString stringWithFormat:@"name CONTAINS[c] \"%@\"", searchText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:searchPredicate];
    searchResults = [route.stops filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"Searching for %@", searchString);
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];

    return YES;
}

- (IBAction)showSearchBar:(id)sender {
    // Scroll to the top of the table, no longer CGPointZero in iOS 7, must consider inset content like the search bar
    CGPoint top = CGPointMake(self.tableView.contentOffset.x, -self.tableView.contentInset.top);
    [self.tableView setContentOffset:top animated:NO];
    [searchBar becomeFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    searchResults = nil;
}


@end
