//
//  PWSearchResultsAttachPanel.h
//  PureWiki
//
//  Created by Tong G. on 8/20/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Cocoa;

// PWSearchResultsAttachPanel class
@interface PWSearchResultsAttachPanel : NSPanel

#pragma mark Outlets
@property ( weak ) IBOutlet NSVisualEffectView* panelVEView;

#pragma mark Hack
// Just in case Apple decides to make `_cornerMask` public and remove the underscore prefix,
// we name the property `cornerMask`.
@property ( weak ) NSImage* cornerMask;

// This private method is called by AppKit and should return a mask image that is used to
// specify which parts of the window are transparent. This works much better than letting
// the window figure it out by itself using the content view's shape because the latter
// method makes rounded corners appear jagged while using `_cornerMask` respects any
// anti-aliasing in the mask image.
- ( NSImage* ) _cornerMask;

@end // PWSearchResultsAttachPanel class