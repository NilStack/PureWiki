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

@dynamic statusProducer;

#pragma mark Dynmaic Properties
- ( void ) setStatusProducer: ( PWWikiContentViewController* __nullable )_StatusProducer
    {
    self->_statusProducer = _StatusProducer;

    PWWikiContentView* wikiContentView = self->_statusProducer.wikiContentView;

    [ self.goBackButton setTarget: wikiContentView ];
    [ self.goBackButton setAction: @selector( goBackAction: ) ];

    [ self.goForwardButton setTarget: wikiContentView ];
    [ self.goForwardButton setAction: @selector( goForwardAction: ) ];

    [ self reload ];
    }

- ( PWWikiContentViewController* ) statusProducer
    {
    return self->_statusProducer;
    }

#pragma mark Actions
- ( void ) reload
    {
    PWWikiContentView* wikiContentView = self->_statusProducer.wikiContentView;

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