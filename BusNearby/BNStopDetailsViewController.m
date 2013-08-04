//
//  BNStopDetailsViewController.m
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BNStopDetailsViewController.h"

@interface BNStopDetailsViewController () {
    NSDictionary *apiData;
    BusStopREST *bench;
}

@property (nonatomic, retain) BusStopREST *bench;
@property (nonatomic, retain) NSDictionary *apiData;

@end

@implementation BNStopDetailsViewController

@synthesize apiData, bench, stopData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        apiData = [[NSDictionary alloc] init];
        bench = [[BusStopREST alloc] init];
        self.arrivalsTableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stopIdLabel.text = stopData[@"code"];
    self.stopNameLabel.text = stopData[@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API

- (void)updateAPIData
{
    apiData = [bench arrivalsAndDeparturesForStop:stopData[@"id"]];
    [self.arrivalsTableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of sections in tableview");
    // Return the number of rows in the section.
    return 5;
    return [apiData[@"data"][@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *stopData = [self dataForIndexPath:indexPath];
    
//    NSArray *routesArray = apiData[@"data"][@"references"][@"routes"];
//
    UILabel *stopId = (UILabel *)[cell viewWithTag:1];
    stopId.text = @"hai";
//    UILabel *stopName = (UILabel *)[cell viewWithTag:2];
//    stopName.text = stopData[@"name"];
//    UILabel *direction = (UILabel *)[cell viewWithTag:4];
//    direction.text = stopData[@"direction"];
//    UILabel *routes = (UILabel *)[cell viewWithTag:3];
//    NSMutableString *routesText = [NSMutableString string];
//    for (NSString *routeId in stopData[@"routeIds"]) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", routeId];
//        NSArray *filtered = [routesArray filteredArrayUsingPredicate:predicate];
//        [routesText appendFormat:@"%@ ", filtered[0][@"shortName"]];
//    }
//    routes.text = routesText;
    
    return cell;
}

-(NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    return apiData[@"data"][@"list"][indexPath.row];
}

@end
