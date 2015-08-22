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

#import "PWStackContainerView.h"
#import "PWActionNotifications.h"
#import "PWWikiContentView.h"
#import "PWWikiContentViewController.h"

#import "WikiPage.h"

#import "PureLayout.h"

// Private Interfaces
@interface PWStackContainerView ()

- ( void ) _tabsSelectionDidChange: ( NSNotification* )_Notif;

@end // Private Interfaces

// PWStackContainerView class
@implementation PWStackContainerView

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->_pagesStack = [ NSMutableDictionary dictionary ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _tabsSelectionDidChange: )
                                                        name: PureWikiTabsSelectionDidChangeNotif
                                                      object: nil ];
        }

    return self;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    [ [ NSColor whiteColor ] set ];
    NSRectFill( _DirtyRect );
    }

#pragma mark Private Interfaces
- ( void ) _tabsSelectionDidChange: ( NSNotification* )_Notif
    {
    WikiPage* wikiPage = _Notif.userInfo[ kPage ];

    if ( !( self->_pagesStack[ wikiPage ] ) )
        {
        PWWikiContentViewController* wikiContentViewController = [ PWWikiContentViewController controllerWithWikiPage: wikiPage owner: self ];

        if ( wikiContentViewController )
            [ self->_pagesStack addEntriesFromDictionary: @{ wikiPage : wikiContentViewController } ];
        }

    [ self setSubviews: @[] ];
    PWWikiContentViewController* contentViewController = self->_pagesStack[ wikiPage ];
    [ self addSubview: contentViewController.view ];
    [ contentViewController.view autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero ];

//    NSLog( @"Fucking Page: %@", _Notif.userInfo[ kPage ] );
    }

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