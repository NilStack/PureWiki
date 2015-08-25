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

#import "PWWikiPageImageCell.h"

// PWWikiPageImageCell class
@implementation PWWikiPageImageCell

@dynamic imageOutlinePath;

- ( void ) awakeFromNib
    {
    self->_imageFillColor = [ [ NSColor grayColor ] colorWithAlphaComponent: .4f ];
    }

#pragma mark Custom Drawing
- ( void ) drawWithFrame: ( NSRect )_CellFrame
                  inView: ( nonnull NSView* )_ControlView
    {
    if ( !self->_imageOutlinePath )
        {
        self->_imageOutlinePath = [ NSBezierPath bezierPathWithOvalInRect: NSInsetRect( _ControlView.bounds, 1.f, 1.f ) ];
//        self->_imageOutlinePath = [ NSBezierPath bezierPathWithRoundedRect: NSInsetRect( _ControlView.bounds, 1.f, 1.f ) xRadius: 8.f yRadius: 8.f ];
        [ self->_imageOutlinePath setLineWidth: 1.f ];
        }

    [ self->_imageOutlinePath addClip ];
    [ [ NSColor whiteColor ] set ];

    NSImage* image = ( NSImage* )[ self objectValue ];
    if ( image )
        [ image drawInRect: _ControlView.bounds fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.f ];
    else
        NSRectFill( _CellFrame );

    if ( self.isHighlighted )
        {
        [ self->_imageFillColor setFill ];
        [ self->_imageOutlinePath fill ];
        }
    }

- ( NSBezierPath* ) imageOutlinePath
    {
    return self->_imageOutlinePath;
    }

@end // PWWikiPageImageCell class

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