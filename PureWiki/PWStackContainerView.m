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
#import "TKSafariSearchbar.h"
#import "TKSafariSearchbarController.h"

#import "SugarWiki.h"

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
        self->_wikiEngine = [ WikiEngine engineWithISOLanguageCode: @"en" ];

        self->_pagesStack = [ NSMutableArray array ];
        self->_contentViewControllers = [ NSMutableDictionary dictionary ];

        self->_KVOController = [ FBKVOController controllerWithObserver: self ];

        // Conforms to <PWWikiContentViewOwner>
        self->_currentConsumers = ( PWWikiContentViewStatusConsumers* )[ NSMutableSet set ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _userDidPickUpSearchItem: )
                                                        name: PureWikiDidPickUpSearchItemNotif
                                                      object: nil ];
        }

    return self;
    }

- ( void ) awakeFromNib
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
                [ self.navButtonsPairView setStatusProducer: contentViewController.wikiContentView ];
                [ self.safariSearchbarController setStatusProducer: contentViewController.wikiContentView ];

                self->_currentWikiContentViewController = contentViewController;

                [ self setSubviews: @[] ];
                [ self addSubview: contentViewController.view ];
                [ contentViewController.view autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero ];
                }
            } ];

    [ self->_currentConsumers addObjectsFromArray:@[ self.navButtonsPairView
                                                   , self.safariSearchbarController
                                                   ] ];
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

#pragma mark Conforms to <PWWikiContentViewOwner>
@dynamic currentConsumers;

- ( PWWikiContentViewStatusConsumers* ) currentConsumers
    {
    return self->_currentConsumers;
    }

#pragma mark Private Interfaces
- ( void ) _userDidPickUpSearchItem: ( NSNotification* )_Notif
    {
    WikiSearchResult* pickedSearchResult = _Notif.userInfo[ kSearchResult ];

    [ self->_wikiEngine pagesWithTitles: @[ pickedSearchResult.title ]
                           continuation: nil
                                success:
    ^( NSArray <WikiPage*>* _MatchedPage, WikiContinuation* _Continuation )
        {
        if ( _MatchedPage.count > 0 )
            {
            WikiPage* pickedWikiPage = _MatchedPage.firstObject;
            PWWikiContentViewController* wikiContentViewController = [ PWWikiContentViewController controllerWithWikiPage: pickedWikiPage owner: self ];

            if ( wikiContentViewController )
                {
                PWOpenedWikiPage* openedWikiPage = [ PWOpenedWikiPage openedWikiPageWithHostContentViewUUID: wikiContentViewController.UUID
                                                                                             openedWikiPage: pickedWikiPage
                                                                                                        URL: pickedWikiPage.URL ];
                [ self->_pagesStack addObject: openedWikiPage ];
                self->_contentViewControllers[ wikiContentViewController.UUID ] = wikiContentViewController;

                [ self.sidebarTabsTableController pushOpenedWikiPage: openedWikiPage ];
                }
            }
        } failure:
            ^( NSError* _Error )
                {

                } stopAllOtherTasks: NO ];

    [ self.window makeFirstResponder: self ];
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