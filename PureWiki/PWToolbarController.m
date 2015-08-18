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

#import "PWToolbarController.h"

// Private Interfaces
@interface PWToolbarController ()

- ( NSToolbarItem* ) _toolbarWithIdentifier: ( NSString* )_Identifier
                                      label: ( NSString* )_Label
                                paleteLabel: ( NSString* )_PaleteLabel
                                    toolTip: ( NSString* )_ToolTip
                                     target: ( id )_Target
                                     action: ( SEL )_ActionSEL
                                itemContent: ( id )_ImageOrView
                                    repMenu: ( NSMenu* )_Menu;
@end // Private Interfaces

// PWToolbarController class
@implementation PWToolbarController

#pragma mark Conforms to <NSToolbarDelegate>
NSString* const kNavButtonsToolbarItemIdentifier = @"kNavButtonsToolbarItemIdentifier";
NSString* const kSidebarStyleToolbarItemIdentifier = @"kSidebarStyleToolbarItemIdentifier";
NSString* const kSearchbarToolbarItemIdentifier = @"kSearchbarToolbarItemIdentifier";

- ( NSArray* ) toolbarAllowedItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return @[ kNavButtonsToolbarItemIdentifier
            , kSidebarStyleToolbarItemIdentifier
            , NSToolbarFlexibleSpaceItemIdentifier
            , kSearchbarToolbarItemIdentifier
            , NSToolbarFlexibleSpaceItemIdentifier
            ];
    }

- ( NSArray* ) toolbarDefaultItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return @[ kNavButtonsToolbarItemIdentifier
            , kSidebarStyleToolbarItemIdentifier
            , NSToolbarFlexibleSpaceItemIdentifier
            , kSearchbarToolbarItemIdentifier
            , NSToolbarFlexibleSpaceItemIdentifier
            ];
    }

- ( NSToolbarItem* )  toolbar: ( NSToolbar* )_Toolbar
        itemForItemIdentifier: ( NSString* )_ItemIdentifier
    willBeInsertedIntoToolbar: ( BOOL )_Flag
    {
    NSToolbarItem* toolbarItem = nil;
    if ( [ _ItemIdentifier isEqualToString: kNavButtonsToolbarItemIdentifier ] )
        {
        toolbarItem = [ self _toolbarWithIdentifier: _ItemIdentifier
                                              label: NSLocalizedString( @"Go Back", nil )
                                        paleteLabel: NSLocalizedString( @"Go Back", nil )
                                            toolTip: NSLocalizedString( @"Show the previous page", nil )
                                             target: self
                                             action: nil
                                        itemContent: self.navButtons
                                            repMenu: nil ];
        }

    if ( [ _ItemIdentifier isEqualToString: kSidebarStyleToolbarItemIdentifier ] )
        {
        toolbarItem = [ self _toolbarWithIdentifier: _ItemIdentifier
                                              label: NSLocalizedString( @"Sidebar Style", nil )
                                        paleteLabel: NSLocalizedString( @"Sidebar Style", nil )
                                            toolTip: NSLocalizedString( @"Switch the sidebar styles", nil )
                                             target: self
                                             action: nil
                                        itemContent: self.sidebarStyleButton
                                            repMenu: nil ];
        }

    else if ( [ _ItemIdentifier isEqualToString: kSearchbarToolbarItemIdentifier ] )
        {
        toolbarItem = [ self _toolbarWithIdentifier: _ItemIdentifier
                                              label: NSLocalizedString( @"Search Wikipedia", nil )
                                        paleteLabel: NSLocalizedString( @"Search Wikipedia", nil )
                                            toolTip: NSLocalizedString( @"Search Wikipedia in here", nil )
                                             target: self
                                             action: nil
                                        itemContent: self.searchWikipediaBar
                                            repMenu: nil ];
        }

    return toolbarItem;
    }

#pragma mark Private Interfaces
- ( NSToolbarItem* ) _toolbarWithIdentifier: ( NSString* )_Identifier
                                      label: ( NSString* )_Label
                                paleteLabel: ( NSString* )_PaleteLabel
                                    toolTip: ( NSString* )_ToolTip
                                     target: ( id )_Target
                                     action: ( SEL )_ActionSEL
                                itemContent: ( id )_ImageOrView
                                    repMenu: ( NSMenu* )_Menu
    {
    NSToolbarItem* newToolbarItem = [ [ NSToolbarItem alloc ] initWithItemIdentifier: _Identifier ];

    [ newToolbarItem setLabel: _Label ];
    [ newToolbarItem setPaletteLabel: _PaleteLabel ];
    [ newToolbarItem setToolTip: _ToolTip ];

    [ newToolbarItem setTarget: _Target ];
    [ newToolbarItem setAction: _ActionSEL ];

    if ( [ _ImageOrView isKindOfClass: [ NSImage class ] ] )
        [ newToolbarItem setImage: ( NSImage* )_ImageOrView ];

    else if ( [ _ImageOrView isKindOfClass: [ NSView class ] ] )
        [ newToolbarItem setView: ( NSView* )_ImageOrView ];

    if ( _Menu )
        {
        NSMenuItem* repMenuItem = [ [ NSMenuItem alloc ] init ];
        [ repMenuItem setSubmenu: _Menu ];
        [ repMenuItem setTitle: _Label ];
        [ newToolbarItem setMenuFormRepresentation: repMenuItem ];
        }

    return newToolbarItem;
    }

@end // PWToolbarController class

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