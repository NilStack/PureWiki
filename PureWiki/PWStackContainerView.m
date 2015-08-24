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

#import "WikiPage.h"

#import "FBKVOController.h"

#import "PureLayout.h"

// Private Interfaces
@interface PWStackContainerView ()
@end // Private Interfaces

// PWStackContainerView class
@implementation PWStackContainerView

@dynamic currentWikiContentViewController;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->_pagesStack = [ NSMutableDictionary dictionary ];
        self->_KVOController = [ FBKVOController controllerWithObserver: self ];
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
                #if DEBUG
                NSLog( @">>> (Log) Current selected page has been changed: \n%@", _Change );
                #endif

                WikiPage* newSelectedPage = _Change[ @"new" ];

                if ( !( self->_pagesStack[ newSelectedPage ] ) )
                    {
                    PWWikiContentViewController* wikiContentViewController = [ PWWikiContentViewController controllerWithWikiPage: newSelectedPage owner: self ];

                    if ( wikiContentViewController )
                        [ self->_pagesStack addEntriesFromDictionary: @{ newSelectedPage : wikiContentViewController } ];
                    }

                [ self setSubviews: @[] ];
                PWWikiContentViewController* contentViewController = self->_pagesStack[ newSelectedPage ];
                [ self.navButtonsPairView setBindingContentViewController: contentViewController ];
                self->_currentWikiContentViewController = contentViewController;

                [ self addSubview: contentViewController.view ];
                [ contentViewController.view autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero ];
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