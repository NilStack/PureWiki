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

#pragma mark IBActions
- ( IBAction ) goBackAction: ( id )_Sender
    {
    [ self __saveScrollPosition ];
    [ self->_backForwardList goBack ];
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
                                       continuation: nil
                                            success:
                    ^( __SugarArray_of( WikiPage* ) _MatchedPages, WikiContinuation* _Continuation )
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

            [ self __reloadAllStatusConsumers ];
            [ self __restoreScrollPosition ];

            [ self askToBecomeFirstResponder ];
            [ [ ( PWStackContainerView* )( self.owner ) sidebarTabsTableController ] pushOpenedWikiPage: self.currentOpenedWikiPage ];

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

#pragma mark Private Interfaces
- ( void ) __saveScrollPosition
    {
    NSString* xOffset = [ self.__webView stringByEvaluatingJavaScriptFromString: [ NSString stringWithFormat:@"window.pageXOffset" ] ];
    NSString* yOffset = [ self.__webView stringByEvaluatingJavaScriptFromString: [ NSString stringWithFormat:@"window.pageYOffset" ] ];

    [ self->_backForwardList.currentItem setXOffset: xOffset.doubleValue ];
    [ self->_backForwardList.currentItem setYOffset: yOffset.doubleValue ];
    }

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