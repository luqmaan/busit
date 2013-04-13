//
//  RouteCell.h
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *routeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *routeDetailsLabel;

@end
