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
#import "PWNavButtonsPairView.h"
#import "PWSidebarTabsTableController.h"
#import "PWOpenedWikiPage.h"

#import "WikiPage.h"

#import "FBKVOController.h"

#import "PureLayout.h"

// Private Interfaces
@interface PWStackContainerView ()
- ( void ) _userDidPickUpSearchItem: ( NSNotification* )_Notif;
@end // Private Interfaces

// PWStackContainerView class
@implementation PWStackContainerView

@dynamic currentWikiContentViewController;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->_pagesStack = [ NSMutableArray array ];
        self->_contentViewControllers = [ NSMutableDictionary dictionary ];

        self->_KVOController = [ FBKVOController controllerWithObserver: self ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _userDidPickUpSearchItem: )
                                                        name: PureWikiDidPickUpSearchItemNotif
                                                      object: nil ];
        }

    return self;
    }

- ( void ) awakeFromNib
    {
    if ( self.sidebarTabsTableController )
        {
        [ self->_KVOController observe: self.sidebarTabsTableController
                               keyPath: PWSidebarCurrentSelectedPageKVOPath
                               options: NSKeyValueObservingOptionNew
                                 block:
            ( FBKVONotificationBlock )^( id _Observer, id _Object, NSDictionary* _Change)
                {
                PWOpenedWikiPage* newSelectedOpenedPage = _Change[ @"new" ];
                PWWikiContentViewController* contentViewController = self->_contentViewControllers[ newSelectedOpenedPage.hostContentViewUUID ];

                #if DEBUG
                NSLog( @">>> (Log:%s) Current selected page hosting in %@ (%@) has been changed: \n%@"
                     , __PRETTY_FUNCTION__
                     , contentViewController, contentViewController.UUID
                     , _Change
                     );
                #endif

                if ( contentViewController )
                    {
                    [ self.navButtonsPairView setBindingContentViewController: contentViewController ];
                    self->_currentWikiContentViewController = contentViewController;

                    [ self setSubviews: @[] ];
                    [ self addSubview: contentViewController.view ];
                    [ contentViewController.view autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero ];
                    }
                } ];
        }
    }

- ( BOOL ) acceptsFirstResponder
    {
    return YES;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    [ [ NSColor whiteColor ] set ];
    NSRectFill( _DirtyRect );
    }

#pragma mark Dynamic Properties
- ( PWWikiContentViewController* ) currentWikiContentViewController
    {
    return self->_currentWikiContentViewController;
    }

#pragma mark Private Interfaces
- ( void ) _userDidPickUpSearchItem: ( NSNotification* )_Notif
    {
    WikiPage* pickedWikiPage = _Notif.userInfo[ kPage ];
    PWWikiContentViewController* wikiContentViewController = [ PWWikiContentViewController controllerWithWikiPage: pickedWikiPage owner: self ];

    if ( wikiContentViewController )
        {
        PWOpenedWikiPage* openedWikiPage = [ PWOpenedWikiPage openedWikiPageWithHostContentViewUUID: wikiContentViewController.UUID
                                                                                     openedWikiPage: pickedWikiPage ];
        [ self->_pagesStack addObject: openedWikiPage ];
        self->_contentViewControllers[ wikiContentViewController.UUID ] = wikiContentViewController;

        [ self.sidebarTabsTableController pushOpenedWikiPage: openedWikiPage ];
        }
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