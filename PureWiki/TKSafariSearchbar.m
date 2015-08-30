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

#import "TKSafariSearchbar.h"
#import "PWMainWindow.h"
#import "PWSearchResultsAttachPanelController.h"
#import "PWSearchResultsAttachPanel.h"
#import "PWActionNotifications.h"

#import "__TKSearchbarBackingLayer.h"
#import "__TKPlaceholderTextLayer.h"
#import "__TKFrozenTitleTextLayer.h"

#import "WikiPage.h"

// Private Interfaces
@interface TKSafariSearchbar ()

//@property ( assign, readwrite, setter = setFocusing: ) BOOL isFocusing;

- ( void ) _userDidPickUpAnSearchItem: ( NSNotification* )_Notif;
- ( void ) __updateInputState: ( NSText* )_FieldEditor;

@end // Private Interfaces

// TKSafariSearchbar class
@implementation TKSafariSearchbar
    {
@protected
    __TKSearchbarBackingLayer __strong* _backingLayer;
    __TKPlaceholderTextLayer __strong* _placeholderLayer;
    __TKFrozenTitleTextLayer __strong* _frozenTitleTextLayer;
    }

@dynamic isFocusing;
@dynamic attachPanelController;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _userDidPickUpAnSearchItem: )
                                                    name: PureWikiDidPickUpSearchItemNotif
                                                    object: nil ];

    self->_attachPanelController = [ PWSearchResultsAttachPanelController controllerWithRelativeView: self ];
    self->_inputting = NO;

    self->_placeholderLayer = [ __TKPlaceholderTextLayer layerWithContent: @"Search Wikipedia" ];
    self->_frozenTitleTextLayer = [ __TKFrozenTitleTextLayer layerWithContent: @"Search Wikipedia" ];

    self->_backingLayer = [ __TKSearchbarBackingLayer layerWithHostView: self ];

    [ self setLayer: self->_backingLayer ];
    [ self setLayerContentsRedrawPolicy: NSViewLayerContentsRedrawOnSetNeedsDisplay ];
    [ self setWantsLayer: YES ];
    }

- ( BOOL ) wantsUpdateLayer
    {
    return YES;
    }

//- ( BOOL ) wantsUpdateLayer
//    {
//    return YES;
//    }

//- ( void ) updateLayer
//    {
//    [ super updateLayer ];
////
////    NSUInteger sublayersCount = self.layer.sublayers.count;
////    if ( sublayersCount == 2 )
////        {
////        NSLog( @"🍓" );
//        CALayer* parentLayer = self.layer.sublayers.lastObject;
//
//        [ parentLayer setPosition: NSMakePoint( 20.f, 2.f ) ];
//        [ self->_placeholderLayer setPosition: NSMakePoint( 5.f, 4.5f ) ];
//        [ parentLayer addSublayer: self->_placeholderLayer ];
//
//        self->_placeholderLayer.hidden = self->_inputting;
////        }
//
////    NSLog( @"%@", self.layer.sublayers.lastObject.sublayers );
//    }

#pragma mark Dynamic Properties
- ( void ) setFocusing: ( BOOL )_YesOrNo
    {
    self->_isFocusing = _YesOrNo;
    self->_backingLayer.isFocusing = self->_isFocusing;
    }

- ( BOOL ) isFocusing
    {
    return self->_isFocusing;
    }

- ( PWSearchResultsAttachPanelController* ) attachPanelController
    {
    return self->_attachPanelController;
    }

#pragma mark Conforms to <NSTextViewDelegate>
- ( void ) textDidChange: ( nonnull NSNotification* )_Notif
    {
    [ super textDidChange: _Notif ];

    NSTextView* fieldEditor = _Notif.object;
    [ self __updateInputState: fieldEditor ];

    NSString* textContent = [ fieldEditor string ];
    [ self.attachPanelController searchValue: textContent ];
    }

- ( void ) textDidEndEditing: ( nonnull NSNotification* )_Notif
    {
    [ super textDidEndEditing: _Notif ];

    [ self setStringValue: @"" ];
    [ self.attachPanelController closeAttachPanelAndClearResults ];

    [ self __updateInputState: _Notif.object ];
    }

#pragma mark Private Interfaces
- ( void ) _userDidPickUpAnSearchItem: ( NSNotification* )_Notif
    {
    [ self.attachPanelController closeAttachPanelAndClearResults ];
    [ ( PWMainWindow* )( self.window ) makeCurrentWikiContentViewFirstResponder ];
    }

- ( void ) __updateInputState: ( NSText* )_FieldEditor
    {
    NSString* textContent = [ _FieldEditor string ];
    self->_inputting = ( BOOL )( textContent.length );

    [ self setNeedsDisplay ];
    }

@end // TKSafariSearchbar class

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