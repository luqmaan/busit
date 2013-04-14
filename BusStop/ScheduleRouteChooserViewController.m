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

-(IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)done:(id)sender
{
    if(nil != self.delegate)
    {
        [self.delegate didSelectRouteWithId:self.currentKey];
//        [self.delegate performSelector:@selector(didSelectRouteWithId) withObject:self.currentKey];
    }
    [self dismissModalViewControllerAnimated:YES];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Choice"];
    if(nil == cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Choice"];
    cell.textLabel.text = key;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];;
    if([key isEqualToString:self.currentKey])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentKey = self.routeKeys[indexPath.row];
    [tableView reloadData];
}

@end
