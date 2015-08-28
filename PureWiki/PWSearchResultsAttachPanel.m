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
  ██████████████████████████████████████████████████████████████████████████████*/

#import "PWSearchResultsAttachPanel.h"
#import "PWSearchResultsAttachPanelBlurBgView.h"
#import "NSObject+TKSafariSearchbar.h"

// Private Interfaces
@interface PWSearchResultsAttachPanel ()

- ( NSImage* ) _maskImageWithCornerRadius: ( CGFloat )_CornerRadius;

@end // Private Interfaces

// PWSearchResultsAttachPanel class
@implementation PWSearchResultsAttachPanel

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ self setOpaque: NO ];
    self.backgroundColor = [ NSColor clearColor ];
    self.excludedFromWindowsMenu = YES;

    NSImage* maskImage = [ self _maskImageWithCornerRadius: 5.f ];
    self.panelBlurBackgroundView.maskImage = maskImage;

    self.cornerMask = maskImage;
    }

#pragma mark Hack
- ( NSImage* ) _cornerMask
    {
    return self.cornerMask;
    }

#pragma mark Private Interfaces
- ( NSImage* ) _maskImageWithCornerRadius: ( CGFloat )_CornerRadius
    {
    CGFloat edgeLength = 2.f * _CornerRadius + 1.f;
    NSImage* maskImage = [ NSImage imageWithSize: NSMakeSize( edgeLength, edgeLength )
                                         flipped: NO
                                  drawingHandler:
        ^BOOL( NSRect _DstRect )
            {
            NSBezierPath* bezierPath = [ NSBezierPath bezierPathWithRoundedRect: _DstRect xRadius: _CornerRadius yRadius: _CornerRadius ];
            [ [ NSColor whiteColor ] set ];
            [ bezierPath fill ];

            return YES;
            } ];

    [ maskImage setCapInsets: NSEdgeInsetsMake( _CornerRadius, _CornerRadius, _CornerRadius, _CornerRadius ) ];
    return maskImage;
    }

@end // PWSearchResultsAttachPanel class

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