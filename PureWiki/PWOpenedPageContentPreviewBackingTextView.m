/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 _______    _             _                 _                 |██
|                (_______)  (_)           | |               | |                |██
|                    _ _ _ _ _ ____   ___ | |  _ _____  ____| |                |██
|                   | | | | | |  _ \ / _ \| |_/ ) ___ |/ ___)_|                |██
|                   | | | | | | |_| | |_| |  _ (| ____| |    _                 |██
|                   |_|\___/|_|  __/ \___/|_| \_)_____)_|   |_|                |██
|                             |_|                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "PWOpenedPageContentPreviewBackingTextView.h"
#import "NSColor+TKSafariSearchbar.h"

// PWOpenedPageContentPreviewBackingTextView class
@implementation PWOpenedPageContentPreviewBackingTextView

#pragma mark Initializations
- ( instancetype ) initWithFrame: ( NSRect )_Frame
                   textContainer: ( NSTextContainer* )_TextContainer
    {
    if ( self = [ super initWithFrame: _Frame textContainer: _TextContainer ] )
        {
        [ self setEditable: NO ];
        [ self setSelectable: NO ];
        [ self setBackgroundColor: [ NSColor clearColor ] ];
        [ self configureForAutoLayout ];

        [ self setHostRowViewSelected: NO ];
        }

    return self;
    }

#pragma mark Conforms to <PWSubviewOfSidebarTableRowView>
- ( void ) setHostRowViewSelected: ( BOOL )_YesOrNo
    {
    self->__isHostRowViewSelected = _YesOrNo;
    [ self setLinkTextAttributes: @{ NSForegroundColorAttributeName
                                        : self->__isHostRowViewSelected ? [ NSColor whiteColor ] : [ NSColor colorWithHTMLColor: @"0a0a0a" ]
                                   } ];
    }

- ( BOOL ) isHostRowViewSelected
    {
    return self->__isHostRowViewSelected;
    }

@end // PWOpenedPageContentPreviewBackingTextView class

/*=============================================================================┐
|                                                                              |
|                                        `-://++/:-`    ..                     |
|                    //.                :+++++++++++///+-                      |
|                    .++/-`            /++++++++++++++/:::`                    |
|                    `+++++/-`        -++++++++++++++++:.                      |
|                     -+++++++//:-.`` -+++++++++++++++/                        |
|                      ``./+++++++++++++++++++++++++++/                        |
|                   `++/++++++++++++++++++++++++++++++-                        |
|                    -++++++++++++++++++++++++++++++++`                        |
|                     `:+++++++++++++++++++++++++++++-                         |
|                      `.:/+++++++++++++++++++++++++-                          |
|                         :++++++++++++++++++++++++-                           |
|                           `.:++++++++++++++++++/.                            |
|                              ..-:++++++++++++/-                              |
|                             `../+++++++++++/.                                |
|                       `.:/+++++++++++++/:-`                                  |
|                          `--://+//::-.`                                      |
|                                                                              |
└=============================================================================*/