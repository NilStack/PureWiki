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

#import "PWSmartSearchBarController.h"
#import "PWSmartSearchBar.h"
#import "PWSmartSearchBar.h"
#import "PWActionNotifications.h"

#import "WikiEngine.h"
#import "WikiPage.h"

// Private Interfaces
@interface PWSmartSearchBarController ()

// Timer
- ( void ) _timerFireMethod: ( NSTimer* )_Timer;

// Searching
- ( void ) _searchWikiPagesBasedThatHaveValue: ( NSString* )_Value;

@end // Private Interfaces

// PWSmartSearchBarController class
@implementation PWSmartSearchBarController

@dynamic smartSearchBar;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        self->_instantSearchWikiEngine = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
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
        self->_timer = [ NSTimer timerWithTimeInterval: ( NSTimeInterval ).6f
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

        [ self->_instantSearchWikiEngine cancelAll ];

        [ [ NSNotificationCenter defaultCenter ] postNotificationName: PureWikiDidEmptySearchNotif
                                                               object: self
                                                             userInfo: nil ];
        }
    }

#pragma mark Dynamic Properties
- ( PWSmartSearchBar* ) smartSearchBar
    {
    return ( PWSmartSearchBar* )( self.view );
    }

#pragma mark Private Interfaces
- ( void ) _timerFireMethod: ( NSTimer* )_Timer
    {
    #if DEBUG
    NSLog( @">>> (Invocation) %s", __PRETTY_FUNCTION__ );
    #endif

    [ self _searchWikiPagesBasedThatHaveValue: _Timer.userInfo[ @"value" ] ];
    [ _Timer invalidate ];
    }

- ( void ) _searchWikiPagesBasedThatHaveValue: ( NSString* )_Value
    {
    [ self->_instantSearchWikiEngine searchAllPagesThatHaveValue: _Value
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

@end // PWSmartSearchBarController class

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