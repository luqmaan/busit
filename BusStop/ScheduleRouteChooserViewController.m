//
//  ScheduleRouteViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/14/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "ScheduleRouteChooserViewController.h"

@interface ScheduleRouteChooserViewController ()

@end

@implementation ScheduleRouteChooserViewController

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
	// Do any additional setup after loading the view.
    self.routeKeys = [self.routes allKeys];
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
    NSInteger numRows = [self.routeKeys count];
    return numRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.routeKeys[indexPath.row];
    NSDictionary *row = self.routes[key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Choice"];
    if(nil == cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Choice"];
    cell.textLabel.text = row[@"routeId"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
