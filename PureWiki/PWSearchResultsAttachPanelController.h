//
//  PWSearchResultsAttachPanelController.h
//  PureWiki
//
//  Created by Tong G. on 8/20/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Cocoa;

@class PWSearchResultsAttachPanel;

// PWSearchResultsAttachPanelController class
@interface PWSearchResultsAttachPanelController : NSWindowController

#pragma mark Outlets
@property ( weak ) IBOutlet PWSearchResultsAttachPanel* searchResultsAttachPanel;

#pragma mark Initializations
+ ( instancetype ) panelController;

@end // PWSearchResultsAttachPanelController class