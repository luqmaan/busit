//
//  RouteStopsViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "RouteStopsViewController.h"

@interface RouteStopsViewController ()

@end

@implementation RouteStopsViewController

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
        NSString *code1 = stop1.code;
        NSString *code2 = stop2.code;
        if(stop1.code > stop2.code)
            return NSOrderedDescending;
        else
        if(stop1.code < stop2.code)
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
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
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
