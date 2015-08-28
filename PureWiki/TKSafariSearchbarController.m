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

#import "TKSafariSearchbarController.h"
#import "TKSafariSearchbar.h"
#import "TKSafariSearchbar.h"
#import "PWActionNotifications.h"
#import "PWSearchResultsAttachPanelController.h"

// Private Interfaces
@interface TKSafariSearchbarController ()
@end // Private Interfaces

// TKSafariSearchbarController class
@implementation TKSafariSearchbarController

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
    self.smartSearchBar.stringValue = @"";
    [ self.smartSearchBar.attachPanelController closeAttachPanelAndClearResults ];
    }

#pragma mark Dynamic Properties
- ( TKSafariSearchbar* ) smartSearchBar
    {
    return ( TKSafariSearchbar* )( self.view );
    }

@end // TKSafariSearchbarController class

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