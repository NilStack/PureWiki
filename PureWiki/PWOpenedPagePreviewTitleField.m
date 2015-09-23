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

#import "PWOpenedPagePreviewTitleField.h"
#import "PWOpenedWikiPage.h"

#import "SugarWiki.h"

CGFloat static const kLeadingGap = 4.5f;

// PWOpenedPagePreviewTitleField class
@implementation PWOpenedPagePreviewTitleField

@dynamic openedWikiPage;
@dynamic isHostRowViewSelected;

#pragma mark Initializations
- ( instancetype ) initWithFrame: ( NSRect )_Frame
    {
    if ( self = [ super initWithFrame: _Frame ] )
        {
        [ self configureForAutoLayout ];
        [ self setHostRowViewSelected: NO ];
        }

    return self;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSString* drawingContent = self->__openedWikiPage.openedWikiPage.title;
    NSDictionary* drawingAttrs = self->__attrs;

    NSSize occupiedSize = [ drawingContent sizeWithAttributes: drawingAttrs ];
    NSRect occupiedRect = NSMakeRect( kLeadingGap
                                    , ( NSHeight( self.bounds ) - occupiedSize.height ) / 2.f
                                    , occupiedSize.width
                                    , NSHeight( self.bounds )
                                    );

    [ drawingContent drawInRect: occupiedRect withAttributes: drawingAttrs ];
    }

#pragma mark Dynamic Properties
- ( void ) setOpenedWikiPage: ( PWOpenedWikiPage* )_OpenedWikiPage
    {
    self->__openedWikiPage = _OpenedWikiPage;
    [ self setNeedsDisplay: YES ];
    }

- ( PWOpenedWikiPage* ) openedWikiPage
    {
    return self->__openedWikiPage;
    }

#pragma mark Conforms to <PWSubviewOfSidebarTableRowView>
- ( void ) setHostRowViewSelected: ( BOOL )_YesOrNo
    {
    self->__isHostRowViewSelected = _YesOrNo;

    self->__attrs = @{ NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue" size: 15.f ]
                     , NSForegroundColorAttributeName
                        : self->__isHostRowViewSelected ? [ NSColor whiteColor ] : [ NSColor blackColor ]
                     };

    [ self setNeedsDisplay: YES ];
    }

- ( BOOL ) isHostRowViewSelected
    {
    return self->__isHostRowViewSelected;
    }

@end // PWOpenedPagePreviewTitleField class

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