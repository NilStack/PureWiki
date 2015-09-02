//
//  PWOpenedWikiPage.h
//  PureWiki
//
//  Created by Tong G. on 9/2/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

@class WikiPage;

// PWOpenedWikiPage class
// Be used as data item of PWSidebarTabsTable table view
@interface PWOpenedWikiPage : NSObject

@property ( strong, readwrite ) NSString* contentViewUUID;
@property ( strong, readwrite ) WikiPage* currentOpenedWikiPage;

#pragma mark Initializations
+ ( instancetype ) openedWikiPageWithContentViewUUID: ( NSString* )_UUID
                               currentOpenedWikiPage: ( WikiPage* )_WikiPage;

- ( instancetype ) initWithContentViewUUID: ( NSString* )_UUID
                     currentOpenedWikiPage: ( WikiPage* )_WikiPage;

@end // PWOpenedWikiPage class
