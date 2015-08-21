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

#import "PWMainWindowController.h"
#import "PWNavButtonsPairView.h"
#import "PWBrain.h"
#import "PWActionNotifications.h"
#import "PWSmartSearchBar.h"

// Private Interfaces
@interface PWMainWindowController ()

// Timer
- ( void ) _timerFireMethod: ( NSTimer* )_Timer;

// Searching
- ( void ) _searchWikiPagesBasedThatHaveValue: ( NSString* )_Value;

@end // Private Interfaces

// prefixWindowController class
@implementation PWMainWindowController

#pragma mark Initializations
+ ( instancetype ) mainWindowController
    {
    return [ [ [ self class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithWindowNibName: @"PWMainWindow" ] )
        ;

    return self;
    }

#pragma mark IBActions
- ( IBAction ) searchWikipediaAction: ( id )_Sender
    {
    // TODO:
    }

#pragma mark Conforms to <NSTextFieldDelegate>
- ( void ) controlTextDidChange: ( nonnull NSNotification* )_Notif
    {
    NSTextView* fieldView = _Notif.userInfo[ @"NSFieldEditor" ];
    NSString* searchValue = fieldView.string;

    // TODO:
    if ( searchValue.length > 0 )
        {
        [ self->_timer invalidate ];
        self->_timer = [ NSTimer timerWithTimeInterval: ( NSTimeInterval ).4f
                                                target: self
                                              selector: @selector( _timerFireMethod: )
                                              userInfo: @{ @"value" : searchValue }
                                               repeats: NO ];

        [ [ NSRunLoop currentRunLoop ] addTimer: self->_timer forMode: NSDefaultRunLoopMode ];
        }

    // if user emptied the search field
    else if ( searchValue.length == 0 )
        {
        [ self->_timer invalidate ];
        self->_timer = nil;

        [ [ PWBrain wiseBrain ] cancelInstantSearchWiki ];

        [ [ NSNotificationCenter defaultCenter ] postNotificationName: PureWikiDidEmptySearchNotif
                                                               object: self
                                                             userInfo: nil ];
        }
    }

#pragma mark Private Interfaces
- ( void ) _timerFireMethod: ( NSTimer* )_Timer
    {
    NSLog( @"%s", __PRETTY_FUNCTION__ );

    [ self _searchWikiPagesBasedThatHaveValue: _Timer.userInfo[ @"value" ] ];
    [ _Timer invalidate ];
    }

- ( void ) _searchWikiPagesBasedThatHaveValue: ( NSString* )_Value
    {
    [ [ PWBrain wiseBrain ] searchAllPagesThatHaveValue: _Value
                                           inNamespaces: nil
                                                   what: WikiEngineSearchWhatPageText
                                                  limit: 10
                                                success:
        ^( NSArray* _MatchedPages )
            {
            if ( _MatchedPages )
                [ [ NSNotificationCenter defaultCenter ] postNotificationName: PureWikiDidSearchPagesNotif
                                                                       object: self
                                                                     userInfo: @{ kPages : _MatchedPages } ];
            } failure:
                ^( NSError* _Error )
                    {
                    NSLog( @"%@", _Error );
                    } stopAllOtherTasks: YES ];

    [ self.smartSearchBar popupAttachPanel ];
    }

@end // PWMainWindowController

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