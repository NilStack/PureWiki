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
#import "PWSearchResultsAttachPanelController.h"

// Private Interfaces
@interface PWSmartSearchBarController ()
@end // Private Interfaces

// PWSmartSearchBarController class
@implementation PWSmartSearchBarController

@dynamic smartSearchBar;

#pragma mark Initializations
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

    [ self.smartSearchBar.attachPanelController searchValue: searchValue ];
    }

- ( void ) controlTextDidEndEditing: ( nonnull NSNotification* )_Notif
    {
//    #if DEBUG
//    NSLog( @">>> (Log) Instant search will be terminated by closing search results attach panel" );
//    #endif
//    [ self->_instantSearchWikiEngine cancelAll ];
//
//    [ self.smartSearchBar.attachPanelController closeAttachPanel ];
    self.smartSearchBar.stringValue = @"";
    }

#pragma mark Dynamic Properties
- ( PWSmartSearchBar* ) smartSearchBar
    {
    return ( PWSmartSearchBar* )( self.view );
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