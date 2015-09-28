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

#import "PWWikiContentView.h"
#import "PWWikiContentViewController.h"
#import "PWCastrateFactory.h"
#import "PWStackContainerView.h"
#import "PWNavButtonsPairView.h"
#import "PWActionNotifications.h"
#import "PWWikiPageArchive.h"
#import "PWUtilities.h"
#import "PWWikiPageBackForwardList.h"
#import "PWOpenedWikiPage.h"
#import "TKSafariSearchbarController.h"
#import "PWSidebarTabsTableController.h"

#import "SugarWiki.h"

// Private Interfaces
@interface PWWikiContentView ()

@property ( weak ) IBOutlet WebView* __webView;
@property ( strong ) WebView* __backingWebView;
@property ( assign ) CGFloat __progressPercent;

- ( void ) __stopLoading;
- ( void ) __saveScrollPosition;
- ( void ) __restoreScrollPosition;
- ( void ) __reloadAllStatusConsumers;
- ( void ) __progressHUDWithError: ( NSError* )_Error;

@end // Private Interfaces

// PWWikiContentView class
@implementation PWWikiContentView

@dynamic canGoBack;
@dynamic canGoForward;

@dynamic originalWikiPage;
@dynamic currentOpenedWikiPage;
@synthesize owner;

@dynamic UUID;

@dynamic __progressPercent;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->_wikiEngine = [ WikiEngine engineWithISOLanguageCode: @"en" ];

        self->_backForwardList = [ PWWikiPageBackForwardList backForwardList ];
        self.__backingWebView = [ [ WebView alloc ] initWithFrame: NSMakeRect( 0.f, 0.f, 1.f, 1.f ) frameName: nil groupName: nil ];
        self->_UUID = [ @"🐠" stringByAppendingString: PWNonce() ];
        }

    return self;
    }

- ( void ) awakeFromNib
    {
    [ self.__backingWebView setFrameLoadDelegate: self ];
    [ self.__backingWebView setMaintainsBackForwardList: NO ];
    [ self.__backingWebView setResourceLoadDelegate: self ];

    [ self.__webView setPolicyDelegate: self ];
    [ self.__webView setFrameLoadDelegate: self ];
    [ self.__webView setMaintainsBackForwardList: NO ];
    }

#pragma mark Dynamic Properties
- ( BOOL ) canGoBack
    {
    return ( self->_backForwardList.backListCount > 0 );
    }

- ( BOOL ) canGoForward
    {
    return ( self->_backForwardList.forwardListCount > 0 );
    }

- ( void ) setOriginalWikiPage: ( WikiPage* )_WikiPage
    {
    if ( _WikiPage && _WikiPage != self->_originalWikiPage )
        {
        self->_originalWikiPage = _WikiPage;

        [ self __stopLoading ];
        [ self->_backForwardList cleanUp ];

        NSURLRequest* request = [ NSURLRequest requestWithURL: self->_originalWikiPage.URL ];
        [ self.__backingWebView.mainFrame loadRequest: request ];
        }
    }

- ( WikiPage* ) originalWikiPage
    {
    return self->_originalWikiPage;
    }

- ( PWOpenedWikiPage* ) currentOpenedWikiPage
    {
    return self->_backForwardList.currentItem;
    }

- ( NSString* ) UUID
    {
    return self->_UUID;
    }

- ( CGFloat ) __progressPercent
    {
    return self->__currentProgress / self->__totalProgress;
    }

#pragma mark IBActions
- ( IBAction ) goBackAction: ( id )_Sender
    {
    [ self __saveScrollPosition ];
    [ self->_backForwardList goBack ];
    [ self __reloadAllStatusConsumers ];

    [ self.__webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: [ ( PWOpenedWikiPage* )( self->_backForwardList.currentItem ) URL ] ] ];
    }

- ( IBAction ) goForwardAction: ( id )_Sender
    {
    [ self __saveScrollPosition ];
    [ self->_backForwardList goForward ];
    [ self __reloadAllStatusConsumers ];

    [ self.__webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: [ ( PWOpenedWikiPage* )( self->_backForwardList.currentItem ) URL ] ] ];
    }

- ( void ) askToBecomeFirstResponder
    {
    [ self.__webView.window makeFirstResponder: self.__webView ];
    }

#pragma mark Conforms to <WebFrameLoadDelegate>
- ( void )                  webView: ( WebView* )_WebView
    didStartProvisionalLoadForFrame: ( WebFrame* )_Frame
    {
    if ( _WebView == self.__backingWebView )
        {
        if ( self->__progressHUD )
            {
            [ self->__progressHUD hide: YES ];
            [ self->__progressHUD removeFromSuperview ];
            }

        self->__progressHUD = [ [ MBProgressHUD alloc ] initWithView: self ];

        [ self addSubview: self->__progressHUD ];

        [ self->__progressHUD setMode: MBProgressHUDModeIndeterminate ];
        [ self->__progressHUD setLabelText: @"LOADING…" ];

        [ self->__progressHUD setProgress: 0.f ];
        [ self->__progressHUD show: YES ];
        }
    }


- ( void )        webView: ( WebView* )_WebView
    didFinishLoadForFrame: ( WebFrame* )_Frame
    {
    NSError* error = nil;

    if ( _Frame == [ _WebView mainFrame ] )
        {
        if ( _WebView == self.__backingWebView )
            {
            PWWikiPageArchive* castratedWikiPageArchive = nil;

            NSURL* archiveURL =
                [ [ PWCastrateFactory defaultFactory ] castrateFrameOnDisk: _Frame error: &error archive: &castratedWikiPageArchive ];

            if ( !error )
                {
                [ self->_wikiEngine pagesWithTitles: @[ castratedWikiPageArchive.wikiPageTitle ]
                                  parseLastRevision: YES
                                       continuation: nil
                                            success:
                    ^( __SugarArray_of( WikiPage* ) _MatchedPages, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
                        {
                        if ( _MatchedPages )
                            {
                            [ self __saveScrollPosition ];
                            [ self.__webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: archiveURL ] ];

                            // Resume routing navigation action
                            [ self.__webView setPolicyDelegate: self ];

                            PWOpenedWikiPage* openedWikiPage =
                                [ PWOpenedWikiPage openedWikiPageWithHostContentViewUUID: self.UUID
                                                                          openedWikiPage: _MatchedPages.firstObject
                                                                                     URL: archiveURL ];
                            [ self->_backForwardList addItem: openedWikiPage ];
                            }
                        } failure:
                            ^( NSError* _Error )
                                {
                                [ self __progressHUDWithError: _Error ];
                                } stopAllOtherTasks: YES ];
                }
            else
                NSLog( @"%@", error );
            }

        else if ( _WebView == self.__webView )
            {
            [ self __restoreScrollPosition ];

            [ self askToBecomeFirstResponder ];
            [ [ ( PWStackContainerView* )( self.owner ) sidebarTabsTableController ] pushOpenedWikiPage: self.currentOpenedWikiPage ];
            [ self __reloadAllStatusConsumers ];

            [ self->__progressHUD hide: YES ];
            }
        }
    }

- ( void )                  webView: ( WebView* )_Sender
    didFailProvisionalLoadWithError: ( NSError* )_Error
                           forFrame: ( WebFrame* )_Frame
    {
    if ( _Sender == self.__backingWebView )
        [ self __progressHUDWithError: _Error ];
    }

- ( void )       webView: ( WebView* )_Sender
    didFailLoadWithError: ( NSError* )_Error
                forFrame: ( WebFrame* )_Frame
    {
    if ( _Sender == self.__backingWebView )
        [ self __progressHUDWithError: _Error ];
    }

#pragma mark Conforms to <WebPolicyDelegate>

- ( void )          webView: ( WebView* )_WebView
    decidePolicyForMIMEType: ( NSString* )_Type
                    request: ( NSURLRequest* )_Request
                      frame: ( WebFrame* )_Frame
           decisionListener: ( id <WebPolicyDecisionListener> )_Listener
    {
    // TODO:
    }

// Routes all the navigation action that occured in self.__webView
- ( void )                  webView: ( WebView* )_WebView
    decidePolicyForNavigationAction: ( NSDictionary* )_ActionInformation
                            request: ( NSURLRequest* )_Request
                              frame: ( WebFrame* )_Frame
                   decisionListener: ( id <WebPolicyDecisionListener> )_Listener
    {
    if ( _WebView == self.__webView )
        {
        // Pause routing navigation action to avoid the infinite recursion
        [ self.__webView setPolicyDelegate: nil ];

        if ( [ _Request.URL.scheme isEqualToString: @"file" ] )
            [ _Listener use ];
        else
            {
            [ self __stopLoading ];

            NSString* beginningURL = [ NSString stringWithFormat: @"https://%@.wikipedia.org", self->_wikiEngine.ISOLanguageCode ];
            if ( [ _Request.URL.absoluteString hasPrefix: beginningURL ] )
                [ self.__backingWebView.mainFrame loadRequest: _Request ];
            else
                [ [ NSWorkspace sharedWorkspace ] openURL: _Request.URL ];

            [ _Listener ignore ];
            }

        [ self.__webView setPolicyDelegate: self ];
        }
    }

#pragma mark Private Interfaces
- ( void ) __stopLoading
    {
    [ self.__webView.mainFrame stopLoading ];
    [ self.__backingWebView.mainFrame stopLoading ];
    }

- ( void ) __saveScrollPosition
    {
    NSString* xOffset = [ self.__webView stringByEvaluatingJavaScriptFromString: [ NSString stringWithFormat:@"window.pageXOffset" ] ];
    NSString* yOffset = [ self.__webView stringByEvaluatingJavaScriptFromString: [ NSString stringWithFormat:@"window.pageYOffset" ] ];

    [ self->_backForwardList.currentItem setXOffset: xOffset.doubleValue ];
    [ self->_backForwardList.currentItem setYOffset: yOffset.doubleValue ];
    }

NSString* const sScrollAnimationJS =
@""
"   var initPos = window.pageYOffset;"
"   var currentPos = initPos;"
"   var desXPos = %g;"
"   var desPos = %g;"
"   var step = desPos / 10.0;"

"   function doScroll()"
"      {"
"      var shouldContinue = false;"

"      if ( desPos > initPos )"
"          shouldContinue = currentPos < desPos;"
"       else if ( desPos < initPos )"
"           shouldContinue = currentPos > desPos;"

"       if ( shouldContinue )"
"           {"
"           ( desPos > currentPos ) ? ( currentPos += step )"
"                                   : ( currentPos -= step );"

"           window.scrollTo( desXPos, currentPos );"
"           setTimeout( doScroll, 20 );"
"           }"
"       }"

"   window.onload = doScroll();";

- ( void ) __restoreScrollPosition
    {
    [ self.__webView stringByEvaluatingJavaScriptFromString:
    [ NSString stringWithFormat:@"window.scrollTo( %g, %g )", self->_backForwardList.currentItem.xOffset, self->_backForwardList.currentItem.yOffset ] ];
    }

- ( void ) __reloadAllStatusConsumers
    {
    for ( id <PWWikiContentViewStatusConsumer> _Consumer in self.owner.currentConsumers )
        if ( _Consumer.statusProducer == self )
            [ _Consumer reload ];
    }

- ( void ) __progressHUDWithError: ( NSError* )_Error
    {
    NSLog( @">>> (Error) Error loading Wiki page due to %@", _Error );

    [ self->__progressHUD setMode: MBProgressHUDModeText ];
    [ self->__progressHUD setLabelText: @"Oops!" ];
    [ self->__progressHUD hide: YES afterDelay: 3.f ];
    }

@end // PWWikiContentView class

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