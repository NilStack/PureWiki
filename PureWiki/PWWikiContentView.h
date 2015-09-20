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

@import Cocoa;
@import WebKit;

#import "MBProgressHUD.h"

@class PWCastrateFactory;
@class PWStackContainerView;
@class PWNavButtonsPairView;
@class PWWikiPageBackForwardList;
@class PWOpenedWikiPage;
@class TKSafariSearchbarController;

@class WikiPage;
@class WikiEngine;

@protocol PWWikiContentViewOwner;
@protocol PWWikiContentViewStatusConsumer;

// PWWikiContentView class
@interface PWWikiContentView : NSView <WebFrameLoadDelegate, WebPolicyDelegate, MBProgressHUDDelegate>
    {
@private
    WikiEngine __strong* _wikiEngine;

    WikiPage __strong* _originalWikiPage;
    PWWikiPageBackForwardList __strong* _backForwardList;
    #if DEBUG
    WebBackForwardList __strong* _debuggingBFList;
    #endif

    NSString __strong* _UUID;

    MBProgressHUD* __progressHUD;
    }

#pragma mark Ivar Properties
@property ( weak, readwrite ) id <PWWikiContentViewOwner> owner;

@property ( assign, readonly ) BOOL canGoBack;
@property ( assign, readonly ) BOOL canGoForward;

@property ( strong, readwrite ) WikiPage* originalWikiPage;
@property ( strong, readonly ) PWOpenedWikiPage* currentOpenedWikiPage;

@property ( strong, readonly ) NSString* UUID;

#pragma mark IBActions
- ( IBAction ) goBackAction: ( id )_Sender;
- ( IBAction ) goForwardAction: ( id )_Sender;

- ( void ) askToBecomeFirstResponder;

@end // PWWikiContentView class

// PWWikiContentViewOwner protocol
typedef NSMutableSet <__kindof id <PWWikiContentViewStatusConsumer> > PWWikiContentViewStatusConsumers;

@protocol PWWikiContentViewOwner <NSObject>

@required
@property ( strong, readonly ) PWWikiContentViewStatusConsumers* currentConsumers;

@end // PWWikiContentViewOwner protocol

// PWWikiContentViewStatusConsumer protocol
@protocol PWWikiContentViewStatusConsumer <NSObject>

@property ( weak, readwrite ) PWWikiContentView* statusProducer;

- ( void ) reload;

@end // PWWikiContentViewStatusConsumer protocol

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