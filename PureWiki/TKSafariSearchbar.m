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

#import "TKSafariSearchbar.h"
#import "PWMainWindow.h"
#import "PWSearchResultsAttachPanelController.h"
#import "PWSearchResultsAttachPanel.h"
#import "PWActionNotifications.h"

#import "__TKPlaceholderLayer.h"

#import "WikiPage.h"

// Private Interfaces
@interface TKSafariSearchbar ()

- ( void ) _userDidPickUpAnSearchItem: ( NSNotification* )_Notif;

@end // Private Interfaces

// TKSafariSearchbar class
@implementation TKSafariSearchbar
    {
@protected
    __TKPlaceholderLayer __strong* _placeholderLayer;
    }

@dynamic attachPanelController;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ self setWantsLayer: YES ];

    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _userDidPickUpAnSearchItem: )
                                                    name: PureWikiDidPickUpSearchItemNotif
                                                    object: nil ];

    self->_attachPanelController = [ PWSearchResultsAttachPanelController controllerWithRelativeView: self ];

    self->_placeholderLayer = [ __TKPlaceholderLayer layerWithContent: @"Search Wikipedia" ];

//    NSButton* testButton = [ [ NSButton alloc ] initWithFrame: NSMakeRect( 20.f, -12.f, 20.f, 50.f ) ];
//    [ testButton setBezelStyle: NSHelpButtonBezelStyle ];
//    [ testButton setImagePosition: NSImageOnly ];
//    [ self addSubview: testButton ];

    }

- ( BOOL ) wantsUpdateLayer
    {
    return YES;
    }

- ( void ) updateLayer
    {
    [ super updateLayer ];

    if ( self.layer.sublayers.count == 2 )
        {
        CALayer* parentLayer = self.layer.sublayers.lastObject;

        [ self->_placeholderLayer setPosition: NSMakePoint( 5.f, 4.f ) ];
        [ parentLayer addSublayer: self->_placeholderLayer ];
        }

    NSLog( @"%@", self.layer.sublayers.lastObject.sublayers );
    }

#pragma mark Dynamic Properties
- ( PWSearchResultsAttachPanelController* ) attachPanelController
    {
    return self->_attachPanelController;
    }

#pragma mark Private Interfaces
- ( void ) _userDidPickUpAnSearchItem: ( NSNotification* )_Notif
    {
    [ self.attachPanelController closeAttachPanelAndClearResults ];
    [ ( PWMainWindow* )( self.window ) makeCurrentWikiContentViewFirstResponder ];
    }

@end // TKSafariSearchbar class

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