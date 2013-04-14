//
//  StopScheduleViewController.m
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "StopScheduleViewController.h"
#import "MBProgressHUD.h"
#import "BusStopREST.h"

@interface StopScheduleViewController ()

@end

@implementation StopScheduleViewController

-(IBAction)routerFilterTapped:(id)sender
{
    NSLog(@"filter routes");
    
#if 0
   //the view controller you want to present as popover
    YourViewController *controller = [[YourViewController alloc] init]; 

    //our popover
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller]; 

    //the popover will be presented from the okButton view 
    [popover presentPopoverFromView:okButton]; 
#endif

}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
