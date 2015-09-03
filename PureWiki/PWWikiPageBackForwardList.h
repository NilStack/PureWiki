/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 ______                   _  _  _ _ _     _ _                 |██
|                (_____ \                 (_)(_)(_|_) |   (_) |                |██
|                 _____) )   _  ____ _____ _  _  _ _| |  _ _| |                |██
|                |  ____/ | | |/ ___) ___ | || || | | |_/ ) |_|                |██
|                | |    | |_| | |   | ____| || || | |  _ (| |_                 |██
|                |_|    |____/|_|   |_____)\_____/|_|_| \_)_|_|                |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

@import Foundation;

@class PWOpenedWikiPage;

// PWWikiPageBackForwardList class
// All interfaces are compatible with WebBackForwardList
@interface PWWikiPageBackForwardList : NSObject
    {
@protected
    // @[ PWOpenedWikiPage, … ]
    NSMutableArray __strong* __backingStore;
    NSInteger __cursor;
    }

#pragma mark Initializations
+ ( instancetype ) backForwardList;

#pragma mark Adding and Removing Items
/** Inserts an opened Wiki page into the back-forward list, immediately after the current item.

  @discussion Any opened Wiki page following item in the back-forward list are removed.
  */
- ( void ) addItem: ( PWOpenedWikiPage* )_OpendedWikiPage;

#pragma mark Moving Backward and Forward
/** Moves backward one page in the back-forward list.

  @discussion This method works by changing the current opened page to the page that precedes it. 
              This method does nothing if no page precedes the current page.
  */
- ( void ) goBack;

/** Moves forward one page in the back-forward list.

  @discussion This method works by changing the current page to the page that follows it. 
              This method does nothing if no item follows the current item.
  */
- ( void ) goForward;

#pragma mark Querying the Back-Forward List
/** Returns the page that precedes the current page in the back-forward list.

  @return The page that precedes the current page in the back-forward list, or nil if none precedes it.
  */
- ( PWOpenedWikiPage* ) backItem;

/** Returns the current page in the back-forward list.

  @return The current page, or nil if the back-forward list is empty.
  */
- ( PWOpenedWikiPage* ) currentItem;

/** Returns the page that follows the current page in the back-forward list.

  @return The page that follows the current page in the back-forward list, or nil if none follows it.
  */
- ( PWOpenedWikiPage* ) forwardItem;

/** Returns the number of pages that precede the current page in the back-forward list.

  @return The number of pages that precede the current page in the back-forward list.
  */
- ( NSInteger ) backListCount;

/** Returns the number of pages that follow the current page in the back-forward list.

  @return The number of pages that follow the current page.
  */
- ( NSInteger ) forwardListCount;

/** Returns a Boolean value indicating whether the back-forward list contains the specified page.

  @param _OpenedPage The page to find in the back-forward list.

  @return YES if the specified page is in the back-forward list; otherwise, NO.
  */
- ( BOOL ) containsItem: ( PWOpenedWikiPage* )_OpenedPage;

@end // PWWikiPageBackForwardList class

/*===============================================================================┐
|                                                                                | 
|                      ++++++     =++++~     +++=     =+++                       | 
|                        +++,       +++      =+        ++                        | 
|                        =+++       ~+++     +        =+                         | 
|                         +++=       =++=   +=        +                          | 
|                          +++        +++= +=        +=                          | 
|                          =+++        ++++=        =+                           | 
|                           +++=       =+++         +                            | 
|                            +++~       +++=       +=                            | 
|                            ,+++      ~++++=     ==                             | 
|                             ++++     +  +++     +                              | 
|                              +++=   +   ~+++   +,                              | 
|                               +++  +:    =+++ ==                               | 
|                               =++++=      +++++                                | 
|                                +++=        +++                                 | 
|                                 ++          +=                                 | 
|                                                                                | 
└===============================================================================*/