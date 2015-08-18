//
//  PWAppDelegate.h
//  PureWiki
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Cocoa;

@class PWMainWindowController;

// PWAppDelegate class
@interface PWAppDelegate : NSObject <NSApplicationDelegate>

@property ( strong ) PWMainWindowController* mainWindowController;

@end // PWAppDelegate class