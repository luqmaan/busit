
//
//  main.m
//  BusStop
//
//  Created by Chris Woodard on 4/12/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PXEngine/PXEngine.h>

#import "BusStopAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [PXEngine licenseKey:@"B4Q0F-A3ECP-C90JO-LVNS4-7304Q-U4C1R-M4BFI-IOILJ-39SQ4-OU79H-ND3LU-4ACRG-0DMNR-9STA5-URV5G-JU" forUser:@"ldawoodjee@gmail.com"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([BusStopAppDelegate class]));
    }
}
