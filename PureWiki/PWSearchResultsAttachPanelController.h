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
  ██████████████████████████████████████████████████████████████████████████████*/

@import Cocoa;

@class PWSearchResultsAttachPanel;
@class PWSearchResultsTableView;

@class WikiEngine;
@class WikiSearchResult;

// PWSearchResultsAttachPanelController class
@interface PWSearchResultsAttachPanelController : NSWindowController
    <NSTableViewDataSource, NSTableViewDelegate>
    {
@protected
    __strong __SugarMutableArray_of( WikiSearchResult* ) _fetchedResults;    // Used as backing store

    WikiEngine __strong* _instantSearchWikiEngine;
    NSTimer __strong* _timer;

    NSView __weak* _relativeView;
    }

@property ( weak, readonly ) PWSearchResultsAttachPanel* searchResultsAttachPanel;

#pragma mark Outlets
@property ( weak ) IBOutlet PWSearchResultsTableView* searchResultsTableView;

#pragma mark Controlling The Attach Panel
@property ( weak, readwrite ) NSView* relativeView;

- ( void ) popUpAttachPanel;
- ( void ) popUpAttachPanelOnWindow: ( NSWindow* )_ParentWindow at: ( NSPoint )_PointInScreen;
- ( void ) closeAttachPanel;
- ( void ) closeAttachPanelAndClearResults;

#pragma mark Handling Search Results
@property ( assign, readonly ) BOOL hasCompletedInstantSearch;
@property ( assign, readonly ) BOOL isInUse;

- ( void ) searchValue: ( NSString* )SearchValue;

// Stop searching but remains the search results
- ( void ) stopSearching;

// Stop searching and clears all the search results
- ( void ) stopSearchingAndClearResults;

#pragma mark Initializations
+ ( instancetype ) controllerWithRelativeView: ( NSView* )_RelativeView;

@end // PWSearchResultsAttachPanelController class

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