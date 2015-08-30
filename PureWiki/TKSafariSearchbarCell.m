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
        self->_isFocusing = NO;

    return self;
    }

//- ( void ) drawWithFrame: ( NSRect )_CellFrame
//                  inView: ( nonnull NSView* )_ControlView
//    {
//    [ super drawWithFrame: _CellFrame inView: _ControlView ];
//    }

//- ( void ) displayLayer: ( nonnull CALayer* )_Layer
//    {
//    NSLog( @"Display Layer: %@", _Layer );
//    }

//- ( void ) drawInteriorWithFrame: ( NSRect )_CellFrame
//                          inView: ( nonnull NSView* )_ControlView
//    {
//    [ super drawInteriorWithFrame: _CellFrame inView: _ControlView ];
//    }

- ( void ) selectWithFrame: ( NSRect )_CellFrame
                    inView: ( NSView* )_ControlView
                    editor: ( NSText* )_FieldEditor
                  delegate: ( id )_DelegateObject
                     start: ( NSInteger )_SelStart
                    length: ( NSInteger )_SelLength
    {
    [ super selectWithFrame: [ self titleRectForBounds: _CellFrame ]
                     inView: _ControlView
                     editor: _FieldEditor
                   delegate: _DelegateObject
                      start: _SelStart
                     length: _SelLength ];

    [ self.hostControl setFocusing: YES ];
    }
//
//
//- ( void ) editWithFrame: ( NSRect )_CellFrame
//                  inView: ( NSView* )_ControlView
//                  editor: ( NSText* )_FieldEditor
//                delegate: ( id )_DelegateObject
//                   event: ( NSEvent* )_Event
//    {
//    NSLog( @"%s", __PRETTY_FUNCTION__ );
//    [ super editWithFrame: [ self titleRectForBounds: _CellFrame ]
//                   inView: _ControlView
//                   editor: _FieldEditor
//                 delegate: _DelegateObject
//                    event: _Event ];
//    }
//
- ( void ) endEditing: ( NSText* )_FieldEditor
    {
    [ super endEditing: _FieldEditor ];
    [ self.controlView.superview setNeedsDisplay: YES ];

    [ self.hostControl setFocusing: NO ];
    }
//
//- ( void ) highlight: ( BOOL )_Flag
//           withFrame: ( NSRect )_CellFrame
//              inView: ( nonnull NSView* )_ControlView
//    {
//
//    }

#pragma mark Dynmaic Properties
- ( void ) setFocusing: ( BOOL )_YesOrNo
    {
    self->_isFocusing = _YesOrNo;
    self.hostControl.isFocusing = self->_isFocusing;
    }

- ( BOOL ) isFocusing
    {
    return self->_isFocusing;
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