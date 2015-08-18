//
//  PWToolbarController.h
//  PureWiki
//
//  Created by Tong G. on 8/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Cocoa;

@class PWNavButtonsPairView;

@interface PWToolbarController : NSViewController <NSToolbarDelegate>

@property ( weak ) IBOutlet PWNavButtonsPairView* navButtons;
@property ( weak ) IBOutlet NSButton* sidebarStyleButton;

@property ( weak ) IBOutlet NSSearchField* searchWikipediaBar;

@property ( weak ) IBOutlet NSToolbar* toolbar;

@end
