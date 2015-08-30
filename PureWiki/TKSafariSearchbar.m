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

#import "__TKSafariSearchbar.h"
#import "__TKSearchbarBackingLayer.h"

#import "WikiPage.h"

// __TKSearchbarBackingLayer + TKPrivate
@interface __TKSearchbarBackingLayer ( TKPrivate )
@property ( assign, readwrite, setter = setFocusing: ) BOOL isFocusing;
@end

@implementation __TKSearchbarBackingLayer ( TKPrivate )

- ( void ) setFocusing: ( BOOL )_YesOrNo
    {
    self->_isFocusing = _YesOrNo;
    [ self setNeedsDisplay ];
    }

@end // __TKSearchbarBackingLayer + TKPrivate

// Private Interfaces
@interface TKSafariSearchbar ()

- ( void ) _userDidPickUpAnSearchItem: ( NSNotification* )_Notif;
//- ( void ) __updateInputState: ( NSText* )_FieldEditor;

@end // Private Interfaces

// TKSafariSearchbar class
@implementation TKSafariSearchbar
    {
@protected
    __TKSearchbarBackingLayer __strong* _backingLayer;
    }

@dynamic attachPanelController;
@dynamic isFocusing;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _userDidPickUpAnSearchItem: )
                                                    name: PureWikiDidPickUpSearchItemNotif
                                                    object: nil ];

    self->_attachPanelController = [ PWSearchResultsAttachPanelController controllerWithRelativeView: self ];
//    self->_inputting = NO;

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
- ( PWSearchResultsAttachPanelController* ) attachPanelController
    {
    return self->_attachPanelController;
    }

- ( BOOL ) isFocusing
    {
    return self->_isFocusing;
    }    

#pragma mark Conforms to <NSTextViewDelegate>
- ( void ) textDidChange: ( nonnull NSNotification* )_Notif
    {
    [ super textDidChange: _Notif ];

    NSTextView* fieldEditor = _Notif.object;
//    [ self __updateInputState: fieldEditor ];

    NSString* textContent = [ fieldEditor string ];
    [ self.attachPanelController searchValue: textContent ];
    }

- ( void ) textDidEndEditing: ( nonnull NSNotification* )_Notif
    {
    [ super textDidEndEditing: _Notif ];

    [ self setStringValue: @"" ];
    [ self.attachPanelController closeAttachPanelAndClearResults ];

//    [ self __updateInputState: _Notif.object ];
    }

#pragma mark Private Interfaces
- ( void ) _userDidPickUpAnSearchItem: ( NSNotification* )_Notif
    {
    [ self.attachPanelController closeAttachPanelAndClearResults ];
    [ ( PWMainWindow* )( self.window ) makeCurrentWikiContentViewFirstResponder ];
    }

//- ( void ) __updateInputState: ( NSText* )_FieldEditor
//    {
//    NSString* textContent = [ _FieldEditor string ];
//    self->_inputting = ( BOOL )( textContent.length );
//
//    [ self setNeedsDisplay ];
//    }

@end // TKSafariSearchbar class

@implementation TKSafariSearchbar ( TKPrivate )

- ( void ) setFocusing: ( BOOL )_YesOrNo
    {
    self->_isFocusing = _YesOrNo;
    [ self->_backingLayer setFocusing: self->_isFocusing ];
    }

@end

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