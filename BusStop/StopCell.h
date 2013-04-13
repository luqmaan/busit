//
//  StopCell.h
//  BusStop
//
//  Created by Chris Woodard on 4/13/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *stopNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *stopDirectionLabel;
@property (nonatomic, weak) IBOutlet UILabel *stopDistanceLabel;

@end
