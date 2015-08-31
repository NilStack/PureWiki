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

#import "TKSafariSearchbarCell.h"
#import "TKSafariSearchbar.h"
#import "NSColor+TKSafariSearchbar.h"

#import "__TKSafariSearchbar.h"

// Private Interfaces
@interface TKSafariSearchbarCell ()
@property ( assign, readwrite, setter = setFocusing: ) BOOL isFocusing;
@end // Private Interfaces

// TKSafariSearchbarCell class
@implementation TKSafariSearchbarCell

@dynamic isFocusing;

#pragma mark Custom Drawing
- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Decoder
    {
    if ( self = [ super initWithCoder: _Decoder ] )
        {
        self->_isFocusing = NO;
        [ self setPlaceholderString: @"Search Wikipedia" ];
//        NSLog( @"🍍%@", self.font );
//        NSLog( @"🍍%@", [ NSColor textBackgroundColor ] );
//        [ self setPlaceholderAttributedString:
//            [ [ NSAttributedString alloc ] initWithString: @"Search Wikipedia"
//                                               attributes: @{ NSFontAttributeName : [ NSFont systemFontOfSize: 13.f ]
//                                                            , NSForegroundColorAttributeName : [ NSColor colorWithHTMLColor: @"B2B2B2" ]
//                                                            } ] ];
        }

    return self;
    }

- ( void ) selectWithFrame: ( NSRect )_CellFrame
                    inView: ( NSView* )_ControlView
                    editor: ( NSText* )_FieldEditor
                  delegate: ( id )_DelegateObject
                     start: ( NSInteger )_SelStart
                    length: ( NSInteger )_SelLength
    {
    [ super selectWithFrame: NSInsetRect( _CellFrame, 5.f, 0.f )
                     inView: _ControlView
                     editor: _FieldEditor
                   delegate: _DelegateObject
                      start: _SelStart
                     length: _SelLength ];

    [ self.hostControl setFocusing: YES ];
    }

- ( void ) endEditing: ( NSText* )_FieldEditor
    {
    [ super endEditing: _FieldEditor ];
    [ self.controlView.superview setNeedsDisplay: YES ];

    [ self.hostControl setFocusing: NO ];
    }

#pragma mark Dynmaic Properties
- ( void ) setFocusing: ( BOOL )_YesOrNo
    {
    self->_isFocusing = _YesOrNo;
    [ self.hostControl setFocusing: self->_isFocusing ];
    }

- ( BOOL ) isFocusing
    {
    return self->_isFocusing;
    }

#pragma mark Conforms to <CALayerDelegate> Informal Protocol
- ( void ) drawLayer: ( nonnull CALayer* )_Layer
           inContext: ( nonnull CGContextRef )_cgCtx
    {
    NSLog( @"🍎: %s:%@", __PRETTY_FUNCTION__, _Layer );
//    [ super drawLayer: _Layer inContext: _cgCtx ];
    }

- ( void ) displayLayer: ( nonnull CALayer* )_Layer
    {
    NSLog( @"🍎: %s:%@", __PRETTY_FUNCTION__, _Layer );
//    [ super displayLayer: _Layer ];
    }


@end // TKSafariSearchbarCell class

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