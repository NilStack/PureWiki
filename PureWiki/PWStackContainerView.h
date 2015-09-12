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

@import WebKit;

#import "PWWikiContentView.h"

@class PWWikiContentView;
@class PWWikiContentViewController;
@class PWNavButtonsPairView;
@class PWSidebarTabsTableController;
@class TKSafariSearchbarController;

@class WikiEngine;

@class FBKVOController;

// PWStackContainerView class
@interface PWStackContainerView : NSView <PWWikiContentViewOwner>
    {
@protected
    WikiEngine* __strong _wikiEngine;

    NSMutableArray __strong* _pagesStack;                   // @{ PWOpendedWikiPage, … }
    NSMutableDictionary __strong* _contentViewControllers;  // @{ WikiContentViewUUID : WikiContentView, … }

    FBKVOController __strong* _KVOController;

    PWWikiContentViewController __weak* _currentWikiContentViewController;

    // Conforms to <PWWikiContentViewOwner>
    PWWikiContentViewStatusConsumers __strong* _currentConsumers;
    }

#pragma mark Outlets
@property ( weak ) IBOutlet PWSidebarTabsTableController* sidebarTabsTableController;

@property ( weak ) IBOutlet PWNavButtonsPairView* navButtonsPairView;
@property ( weak ) IBOutlet TKSafariSearchbarController* safariSearchbarController;

@property ( weak, readonly ) PWWikiContentViewController* currentWikiContentViewController;

@end // PWStackContainerView class

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