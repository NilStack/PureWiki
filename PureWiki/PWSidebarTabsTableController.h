//
//  PWSidebarTabsTableController.h
//  PureWiki
//
//  Created by Tong G. on 8/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Cocoa;

@class PWSidebarTabsTable;

// PWSidebarTabsTableController class
@interface PWSidebarTabsTableController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
    {
@protected
    NSMutableArray __strong* _openedWikiPages;
    }

@property ( weak ) IBOutlet PWSidebarTabsTable* sidebarTabsTable;

@end // PWSidebarTabsTableController class
