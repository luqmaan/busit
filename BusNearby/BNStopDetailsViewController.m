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
    BNArrivalDeparturesTableViewController *arrivalsDeparturesVC;
}

@property (nonatomic, retain) BusStopREST *bench;
@property (nonatomic, retain) NSDictionary *apiData;
@property (nonatomic, retain) BNArrivalDeparturesTableViewController *arrivalsDeparturesVC;

@end

@implementation BNStopDetailsViewController

@synthesize apiData, bench, stopData, arrivalsDeparturesVC;


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        // Custom initialization
        bench = [[BusStopREST alloc] init];
        apiData = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateAPIData];
    self.stopIdLabel.text = stopData[@"code"];
    self.stopNameLabel.text = stopData[@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setArrivalsDeparturesTableView:nil];
    [super viewDidUnload];
}

#pragma mark - API

- (void)updateAPIData
{
    apiData = [bench arrivalsAndDeparturesForStop:stopData[@"id"]];
    arrivalsDeparturesVC.apiData = apiData;

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"arrivalsDeparturesSegue"]) {
        arrivalsDeparturesVC = segue.destinationViewController;
        arrivalsDeparturesVC.apiData = apiData;
    }
}

@end
