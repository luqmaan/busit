//
//  BNArrivalDeparturesTableViewController.m
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BNArrivalDeparturesTableViewController.h"

@interface BNArrivalDeparturesTableViewController ()

@end

@implementation BNArrivalDeparturesTableViewController

@synthesize apiData;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)updateWith:(NSDictionary *)newApiData
{
    self.apiData = newApiData;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of sections in tableview %d", [apiData[@"data"][@"entry"][@"arrivalsAndDepartures"] count]);
    // Return the number of rows in the section.
    return [apiData[@"data"][@"entry"][@"arrivalsAndDepartures"] count];
}

-(NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    return apiData[@"data"][@"entry"][@"arrivalsAndDepartures"][indexPath.row];
}


#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"arrivalsDeparturesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *data = [self dataForIndexPath:indexPath];
    
    UILabel *routeName = (UILabel *)[cell viewWithTag:1];
    routeName.text = [NSString stringWithFormat:@"%@ %@", data[@"routeShortName"], data[@"routeLongName"]];
    UILabel *tripHeadsign = (UILabel *)[cell viewWithTag:2];
    tripHeadsign.text = data[@"tripHeadsign"];
    #pragma mark - TODO: add proper calculation for distance in miles
    int miles = [(NSNumber *)data[@"distanceFromStop"] intValue] / 500;
    UILabel *distance =  (UILabel *)[cell viewWithTag:3];
    distance.text = [NSString stringWithFormat:@"%dmi %@ stops away", miles, data[@"numberOfStopsAway"]];
    
    
    return cell;
}
@end
