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

#import "PWNavButtonsPairView.h"
#import "PWWikiContentViewController.h"
#import "PWWikiContentView.h"
#import "PWWikiPageBackForwardList.h"

// PWNavButtonsPairView class
@implementation PWNavButtonsPairView

@dynamic bindingContentViewController;

#pragma mark Dynmaic Properties
- ( void ) setBindingContentViewController: ( PWWikiContentViewController* __nullable )_BindingContentViewController
    {
    self->_bindingContentViewController = _BindingContentViewController;

    PWWikiContentView* wikiContentView = self->_bindingContentViewController.wikiContentView;

    [ self.goBackButton setTarget: wikiContentView ];
    [ self.goBackButton setAction: @selector( goBackAction: ) ];

    [ self.goForwardButton setTarget: wikiContentView ];
    [ self.goForwardButton setAction: @selector( goForwardAction: ) ];

    [ self reload ];
    }

- ( PWWikiContentViewController* ) bindingContentViewController
    {
    return self->_bindingContentViewController;
    }

#pragma mark Actions
- ( void ) reload
    {
    PWWikiContentView* wikiContentView = self->_bindingContentViewController.wikiContentView;

    [ self.goBackButton setEnabled: wikiContentView.canGoBack ];
    [ self.goForwardButton setEnabled: wikiContentView.canGoForward ];
    }

@end // PWNavButtonsPairView class

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