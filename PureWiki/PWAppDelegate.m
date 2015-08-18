//
//  PWAppDelegate.m
//  PureWiki
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWAppDelegate.h"
#import "PWMainWindowController.h"

// Private Interfaces
@interface PWAppDelegate ()

@end // Private Interfaces

// PWAppDelegate class
@implementation PWAppDelegate

- ( void ) awakeFromNib
    {
    self.mainWindowController = [ PWMainWindowController mainWindowController ];
    }

- ( void ) applicationWillFinishLaunching: ( nonnull NSNotification* )_Notification
    {
    [ self.mainWindowController showWindow: self ];
    }

@end // PWAppDelegate class
