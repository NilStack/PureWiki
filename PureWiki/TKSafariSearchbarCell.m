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

// TKSafariSearchbarCell class
@implementation TKSafariSearchbarCell

#pragma mark Custom Drawing
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

//- ( void ) selectWithFrame: ( NSRect )_CellFrame
//                    inView: ( NSView* )_ControlView
//                    editor: ( NSText* )_FieldEditor
//                  delegate: ( id )_DelegateObject
//                     start: ( NSInteger )_SelStart
//                    length: ( NSInteger )_SelLength
//    {
//    NSLog( @"%s", __PRETTY_FUNCTION__ );
//    [ super selectWithFrame: [ self titleRectForBounds: _CellFrame ]
//                     inView: _ControlView
//                     editor: _FieldEditor
//                   delegate: _DelegateObject
//                      start: _SelStart
//                     length: _SelLength ];
//    }
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
//- ( void ) endEditing: ( NSText* )_FieldEditor
//    {
//    NSLog( @"%s", __PRETTY_FUNCTION__ );
//    [ super endEditing: _FieldEditor ];
//    [ self.controlView.superview setNeedsDisplay: YES ];
//    }
//
//- ( void ) highlight: ( BOOL )_Flag
//           withFrame: ( NSRect )_CellFrame
//              inView: ( nonnull NSView* )_ControlView
//    {
//
//    }

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