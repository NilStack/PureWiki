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
@end // Private Interfaces

// prefixWindowController class
@implementation PWMainWindowController

#pragma mark Initializers
+ ( instancetype ) mainWindowController
    {
    return [ [ [ self class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithWindowNibName: @"PWMainWindow" ] )
        {
        // TODO:
        }

    return self;
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    // TODO:
    }

#pragma mark IBActions
- ( IBAction ) searchWikipediaAction: ( id )_Sender
    {
    NSString* searchValue = [ ( NSSearchField* )_Sender stringValue ];
    [ [ PWBrain wiseBrain ] searchAllPagesThatHaveValue: searchValue
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
                    } ];

    [ self.smartSearchBar popupSearchAttachMenu ];
//    [ self.fuckingMenu popUpMenuPositioningItem: [ self.fuckingMenu itemAtIndex: 0 ]
//                                     atLocation: NSMakePoint( NSMinX( self.smartSearchBar.frame ) - 3.f, NSMaxY( self.smartSearchBar.frame ) - 3.f )
//                                         inView: self.smartSearchBar ];
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