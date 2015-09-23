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

#import "PWSidebarTableRowView.h"
#import "PWSidebarTabsTableCell.h"
#import "NSColor+TKSafariSearchbar.h"

// PWSidebarTableRowView class
@implementation PWSidebarTableRowView

- ( void ) drawBackgroundInRect: ( NSRect )_DirtyRect
    {
//    NSLog( @"%@ %@  %s", self, self.isSelected ? @"✅" : @"❌", __PRETTY_FUNCTION__ );
//    [ [ NSColor blackColor ] set ];
//    NSRectFill( _DirtyRect );
    [ ( ( PWSidebarTabsTableCell* )[ self viewAtColumn: 0 ] ) setHostRowViewSelected: self.isSelected ];
    }

- ( void ) drawSelectionInRect: ( NSRect )_DirtyRect
    {
//    NSLog( @"%@ %@  %s", self, self.isSelected ? @"✅" : @"❌", __PRETTY_FUNCTION__ );
    if ( self.selectionHighlightStyle == NSTableViewSelectionHighlightStyleRegular )
        {
        NSColor* beautyColor = nil;

        if ( self.isSelected )
            {
            if ( NSApp.active )
                beautyColor = [ [ NSColor colorWithHTMLColor: @"F5A623" ] colorWithAlphaComponent: .65f ];
            else
                beautyColor = [ NSColor colorWithCalibratedWhite: .82f alpha: .65f ];
            }
        else
            beautyColor = [ NSColor clearColor ];

        [ beautyColor setStroke ];
        [ beautyColor setFill ];

        NSBezierPath* selectionPath = [ NSBezierPath bezierPathWithRect: _DirtyRect ];
        [ selectionPath fill ];
        [ selectionPath stroke ];
        }
    }

@end // PWSidebarTableRowView class

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