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
#import "PWSidebarTabsTableController.h"
#import "PWOpenedWikiPage.h"
#import "PWWikiContentViewController.h"
#import "PWWikiContentView.h"

#import "__TKSafariSearchbar.h"
#import "__TKSearchbarBackingLayer.h"
#import "__TKPlaceholderTextLayer.h"

#import "WikiPage.h"

#import "FBKVOController.h"

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
@end // Private Interfaces

// TKSafariSearchbar class
@implementation TKSafariSearchbar
    {
@protected
    __TKSearchbarBackingLayer __strong* _backingLayer;
    }

@dynamic attachPanelController;
@dynamic bindingContentViewController;
@dynamic isFocusing;

@dynamic placeholderString;
@dynamic frozenTitle;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        self->_KVOController = [ FBKVOController controllerWithObserver: self ];

    return self;
    }

- ( void ) awakeFromNib
    {
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _userDidPickUpAnSearchItem: )
                                                    name: PureWikiDidPickUpSearchItemNotif
                                                    object: nil ];

    self->_attachPanelController = [ PWSearchResultsAttachPanelController controllerWithRelativeView: self ];
    self->_backingLayer = [ __TKSearchbarBackingLayer layerWithHostView: self ];

    [ self setLayer: self->_backingLayer ];
    [ self setLayerContentsRedrawPolicy: NSViewLayerContentsRedrawOnSetNeedsDisplay ];
    [ self setWantsLayer: YES ];

    if ( self.sidebarTabsTableController )
        {
        [ self->_KVOController observe: self.sidebarTabsTableController
                               keyPath: PWSidebarCurrentSelectedPageKVOPath
                               options: NSKeyValueObservingOptionNew
                                 block:
            ( FBKVONotificationBlock )^( id _Observer, id _Object, NSDictionary* _Change )
                {
                #if DEBUG
                NSLog( @">>> (Log:%s) Current selected page has been changed: \n%@", __PRETTY_FUNCTION__, _Change );
                #endif

                PWOpenedWikiPage* newSelectedOpenedPage = _Change[ @"new" ];
                [ self setFrozenTitle: [ newSelectedOpenedPage.openedWikiPage title ] ];
                [ self setStringValue: [ newSelectedOpenedPage.openedWikiPage title ] ];
                } ];
        }
    }

#pragma mark Dynamic Properties
- ( PWSearchResultsAttachPanelController* ) attachPanelController
    {
    return self->_attachPanelController;
    }

- ( void ) setBindingContentViewController: ( PWWikiContentViewController* __nullable )_BindingContentViewController
    {
    self->_bindingContentViewController = _BindingContentViewController;
    NSLog( @"🐞%@", self->_bindingContentViewController.wikiContentView.wikiPage.title );
    }

- ( PWWikiContentViewController* ) bindingContentViewController
    {
    return self->_bindingContentViewController;
    }

#pragma mark Actions
- ( void ) reload
    {
    PWWikiContentView* wikiContentView = self->_bindingContentViewController.wikiContentView;
    WikiPage* currentPage = wikiContentView.wikiPage;

    if ( currentPage.title )
        [ self setFrozenTitle: currentPage.title ];
    }

- ( BOOL ) isFocusing
    {
    return self->_isFocusing;
    }

- ( void ) setPlaceholderString: ( NSString* )_PlaceholderString
    {
    self->_backingLayer.placeholderString = _PlaceholderString;
    }

- ( NSString* ) placeholderString
    {
    return self->_backingLayer.placeholderString;
    }

- ( void ) setFrozenTitle: ( NSString* )_FrozenTitle
    {
    self->_backingLayer.frozenTitle = _FrozenTitle;
    }

- ( NSString* ) frozenTitle
    {
    return self->_backingLayer.frozenTitle;
    }

#pragma mark Conforms to <NSTextViewDelegate>
- ( void ) textDidChange: ( nonnull NSNotification* )_Notif
    {
    [ super textDidChange: _Notif ];

    NSTextView* fieldEditor = _Notif.object;
    NSString* textContent = [ fieldEditor string ];
    [ self.attachPanelController searchValue: textContent ];
    }

- ( void ) textDidEndEditing: ( nonnull NSNotification* )_Notif
    {
    [ super textDidEndEditing: _Notif ];
    [ self.attachPanelController closeAttachPanelAndClearResults ];
    }

#pragma mark Private Interfaces
- ( void ) _userDidPickUpAnSearchItem: ( NSNotification* )_Notif
    {
    [ self.attachPanelController closeAttachPanelAndClearResults ];
    [ ( PWMainWindow* )( self.window ) makeCurrentWikiContentViewFirstResponder ];

//    [ self setFrozenTitle: [ _Notif.userInfo[ kPage ] title ] ];
    }

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