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

#import "PWSmartSearchBar.h"
#import "PWSmartSearchAttachMenu.h"
#import "PWSearchResultsAttachPanelController.h"

// PWSmartSearchBar class
@implementation PWSmartSearchBar

@dynamic attachPanelController;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    self->_attachPanelController = [ PWSearchResultsAttachPanelController panelController ];
    }

- ( void ) popupSearchAttachMenu
    {
    if ( self.smartSearchAttachMenu.size.width != NSWidth( self.frame ) )
        {
        NSSize oldSmartSearchAttachMenuSize = self.smartSearchAttachMenu.size;
        oldSmartSearchAttachMenuSize.width = NSWidth( self.frame );
        [ self.smartSearchAttachMenu setSize: oldSmartSearchAttachMenuSize ];
        }

    [ self.smartSearchAttachMenu popUpMenuPositioningItem: [ self.smartSearchAttachMenu itemAtIndex: 0 ]
                                               atLocation: NSMakePoint( NSMinX( self.frame ) - 3.f, NSMaxY( self.frame ) - 3.f )
                                                   inView: self ];
    }

- ( void ) popupAttachPanel
    {
    NSRect windowFrame = [ self convertRect: self.frame toView: nil ];
    NSRect screenFrame = [ self.window convertRectToScreen: windowFrame ];

    NSPoint origin = screenFrame.origin;
    origin.x -= 3.5f;
    origin.y -= NSHeight( self->_attachPanelController.window.frame ) - 4.f;

    [ self->_attachPanelController.window setFrameOrigin: origin ];
    [ self->_attachPanelController.window makeKeyAndOrderFront: self ];
    }

#pragma mark Dynamic Properties
- ( PWSearchResultsAttachPanelController* ) attachPanelController
    {
    return self->_attachPanelController;
    }

@end // PWSmartSearchBar class

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