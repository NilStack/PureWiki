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

- ( void ) __saveScrollPosition;
- ( void ) __restoreScrollPosition;
- ( void ) __reloadAllStatusConsumers;

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
        #if DEBUG
        self->_debuggingBFList = [ [ WebBackForwardList alloc ] init ];
        #endif

        self.__backingWebView = [ [ WebView alloc ] initWithFrame: NSMakeRect( 0.f, 0.f, 1.f, 1.f ) frameName: nil groupName: nil ];
        self->_UUID = [ @"🐠" stringByAppendingString: PWNonce() ];
        }

    return self;
    }

- ( void ) awakeFromNib
    {
    [ self.__backingWebView setFrameLoadDelegate: self ];
    [ self.__backingWebView setResourceLoadDelegate: self ];
    [ self.__backingWebView setMaintainsBackForwardList: NO ];

    [ self.__webView setPolicyDelegate: self ];
    [ self.__webView setFrameLoadDelegate: self ];
    [ self.__webView setMaintainsBackForwardList: NO ];
    }

#pragma mark Dynamic Properties
- ( BOOL ) canGoBack
    {
    #if DEBUG
     NSLog( @">>> (Log%s) 🐙Back List Count: %d vs. %ld", __PRETTY_FUNCTION__, _debuggingBFList.backListCount, _backForwardList.backListCount );
    #endif

    return ( self->_backForwardList.backListCount > 0 );
    }

- ( BOOL ) canGoForward
    {
    #if DEBUG
    NSLog( @">>> (Log%s) 🐙Forward List Count: %d vs. %ld", __PRETTY_FUNCTION__, _debuggingBFList.forwardListCount, _backForwardList.forwardListCount );
    #endif

    return ( self->_backForwardList.forwardListCount > 0 );
    }

- ( void ) setOriginalWikiPage: ( WikiPage* )_WikiPage
    {
    if ( _WikiPage && _WikiPage != self->_originalWikiPage )
        {
        self->_originalWikiPage = _WikiPage;

        [ self.__webView.mainFrame stopLoading ];
        [ self.__backingWebView.mainFrame stopLoading ];

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
    #if DEBUG
    [ self->_debuggingBFList goBack ];
    #endif

    [ self.__webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: [ ( PWOpenedWikiPage* )( self->_backForwardList.currentItem ) URL ] ] ];

    #if DEBUG
    NSLog( @"%@", self->_backForwardList );
    NSLog( @">>> (Log:%s) 🐏:\n{%@\nvs.\n%@}", __PRETTY_FUNCTION__, self->_debuggingBFList, self->_backForwardList );
    NSLog( @">>> (Log:%s) 🐣Back Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, self->_debuggingBFList.backItem, self->_backForwardList.backItem );
    NSLog( @">>> (Log:%s) 🐣Forward Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, self->_debuggingBFList.forwardItem, self->_backForwardList.forwardItem );
    #endif
    }

- ( IBAction ) goForwardAction: ( id )_Sender
    {
    [ self __saveScrollPosition ];
    [ self->_backForwardList goForward ];
    [ self __reloadAllStatusConsumers ];
    #if DEBUG
    [ self->_debuggingBFList goForward ];
    #endif

    [ self.__webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: [ ( PWOpenedWikiPage* )( self->_backForwardList.currentItem ) URL ] ] ];

    #if DEBUG
    NSLog( @">>> (Log:%s) 🐏:\n{%@\nvs.\n%@}", __PRETTY_FUNCTION__, self->_debuggingBFList, self->_backForwardList );
    NSLog( @">>> (Log:%s) 🐣Back Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, self->_debuggingBFList.backItem, self->_backForwardList.backItem );
    NSLog( @">>> (Log:%s) 🐣Forward Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, self->_debuggingBFList.forwardItem, self->_backForwardList.forwardItem );
    #endif
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
        self->__progressHUD = [ [ MBProgressHUD alloc ] initWithView: self ];

        [ self->__progressHUD setMode: MBProgressHUDModeDeterminate ];
        [ self->__progressHUD setLabelText: @"LOADING…" ];

        [ self addSubview: self->__progressHUD ];

        [ self->__progressHUD setProgress: 0.f ];
        [ self->__progressHUD show: YES ];
        }
    }

- ( void )        webView: ( WebView* )_Sender
    didCommitLoadForFrame: ( WebFrame* )_Frame
    {
    self->__totalProgress = ( CGFloat )[ [ ( NSHTTPURLResponse* )_Frame.dataSource.response allHeaderFields ][ @"Content-Length" ] longLongValue ];
    self->__currentProgress = ( CGFloat )( _Frame.dataSource.data.length );
    [ self->__progressHUD setProgress: self.__progressPercent ];
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
                            #if DEBUG
                            [ self->_debuggingBFList addItem: openedWikiPage ];
                            #endif
                            }
                        } failure:
                            ^( NSError* _Error )
                                {
                                NSLog( @"%@", _Error );
                                } stopAllOtherTasks: YES ];
                }
            else
                NSLog( @"%@", error );
            }

        else if ( _WebView == self.__webView )
            {
            [ self.__webView setPolicyDelegate: self ];
            [ self __restoreScrollPosition ];

            [ self askToBecomeFirstResponder ];
            [ [ ( PWStackContainerView* )( self.owner ) sidebarTabsTableController ] pushOpenedWikiPage: self.currentOpenedWikiPage ];

            [ self->__progressHUD hide: YES ];

            #if DEBUG
            NSLog( @">>> (Log:%s) 🌰Current back-forward list:\n{%@\nvs.\n%@}", __PRETTY_FUNCTION__, _debuggingBFList, _backForwardList );
            NSLog( @">>> (Log:%s) 🐣Back Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, _debuggingBFList.backItem, _backForwardList.backItem );
            NSLog( @">>> (Log:%s) 🐣Forward Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, _debuggingBFList.forwardItem, _backForwardList.forwardItem );
            #endif
            }
        }
    }

#pragma mark Conforms to <WebPolicyDelegate>

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
            [ self.__backingWebView.mainFrame loadRequest: _Request ];
            [ _Listener ignore ];
            }
        }
    }

#pragma mark Conforms to <WebResourceLoadDelegate>
- ( id )                webView: ( WebView* )_WebView
    identifierForInitialRequest: ( NSURLRequest* )_Request
                 fromDataSource: ( WebDataSource* )_DataSource
    {
    return _Request.URL.absoluteString;
    }

- ( void )     webView: ( WebView* )_Sender
              resource: ( id )_Identifier
    didReceiveResponse: ( NSURLResponse* )_Response
        fromDataSource: ( WebDataSource* )_DataSource
    {
//    NSLog( @"🍓%@ %lld", _Identifier, [ [ ( NSHTTPURLResponse* )_Response allHeaderFields ][ @"Content-Length" ] longLongValue ] );
//    if ( _Sender == self.__backingWebView )
//        {
//        }
    }

- ( void )          webView: ( WebView* )_Sender
                   resource: ( id )_Identifier
    didReceiveContentLength: ( NSInteger )_Length
             fromDataSource: ( WebDataSource* )_DataSource
    {
    NSLog( @"🍓%lu, %ld", _DataSource.data.length, _Length );
//    if ( _Sender == self.__backingWebView )
//        {
//        if ( [ _Identifier isEqualToString: _DataSource.request.URL.absoluteString ] )
//            {
//            self->__currentProgress = _Length;
//            [ self->__progressHUD setProgress: self.__progressPercent ];

//            NSLog( @"🍍 %@  %g vs. %g", _DataSource.request.URL.absoluteString, self->__currentProgress, self->__totalProgress );

//            if ( self->__currentProgress >= self->__totalProgress )
//                NSLog( @"🍓 %@", _DataSource.request.URL.absoluteString );
//                [ self->__progressHUD setMode: MBProgressHUDModeIndeterminate ];
//            }
//        }
    }

#pragma mark Private Interfaces
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
//        [ NSString stringWithFormat: sScrollAnimationJS, self->_backForwardList.currentItem.xOffset, self->_backForwardList.currentItem.yOffset ] ];
        [ NSString stringWithFormat:@"window.scrollTo( %g, %g )", self->_backForwardList.currentItem.xOffset, self->_backForwardList.currentItem.yOffset ] ];
    }

- ( void ) __reloadAllStatusConsumers
    {
    for ( id <PWWikiContentViewStatusConsumer> _Consumer in self.owner.currentConsumers )
        if ( _Consumer.statusProducer == self )
            [ _Consumer reload ];
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