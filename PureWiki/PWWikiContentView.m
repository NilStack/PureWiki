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
#import "PWCastrateFactory.h"
#import "PWStackContainerView.h"
#import "PWNavButtonsPairView.h"
#import "PWActionNotifications.h"
#import "PWWikiPageArchive.h"
#import "PWUtilities.h"
#import "PWWikiPageBackForwardList.h"
#import "PWOpenedWikiPage.h"

#import "WikiPage.h"
#import "WikiEngine.h"

// Private Interfaces
@interface PWWikiContentView ()

- ( void ) __saveScrollPosition;
- ( void ) __restoreScrollPosition;

@end // Private Interfaces

// PWWikiContentView class
@implementation PWWikiContentView

@dynamic canGoBack;
@dynamic canGoForward;

@dynamic wikiPage;
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

        self->_backingWebView = [ [ WebView alloc ] initWithFrame: NSMakeRect( 0.f, 0.f, 1.f, 1.f ) frameName: nil groupName: nil ];
        self->_UUID = [ @"🐠" stringByAppendingString: PWNonce() ];
        }

    return self;
    }

- ( void ) awakeFromNib
    {
    [ self->_backingWebView setFrameLoadDelegate: self ];
    [ self->_backingWebView setMaintainsBackForwardList: NO ];

    [ self.webView setPolicyDelegate: self ];
    [ self.webView setFrameLoadDelegate: self ];
    [ self.webView setMaintainsBackForwardList: NO ];
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

- ( void ) setWikiPage: ( WikiPage* )_WikiPage
    {
    [ self->_backingWebView.mainFrame stopLoading ];

    NSURLRequest* request = [ NSURLRequest requestWithURL: _WikiPage.URL ];
    [ self->_backingWebView.mainFrame loadRequest: request ];
    }

- ( WikiPage* ) wikiPage
    {
    return [ ( PWOpenedWikiPage* )( self->_backForwardList.currentItem ) openedWikiPage ];
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

    [ self.webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: [ ( PWOpenedWikiPage* )( self->_backForwardList.currentItem ) URL ] ] ];

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

    [ self.webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: [ ( PWOpenedWikiPage* )( self->_backForwardList.currentItem ) URL ] ] ];

    #if DEBUG
    NSLog( @">>> (Log:%s) 🐏:\n{%@\nvs.\n%@}", __PRETTY_FUNCTION__, self->_debuggingBFList, self->_backForwardList );
    NSLog( @">>> (Log:%s) 🐣Back Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, self->_debuggingBFList.backItem, self->_backForwardList.backItem );
    NSLog( @">>> (Log:%s) 🐣Forward Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, self->_debuggingBFList.forwardItem, self->_backForwardList.forwardItem );
    #endif
    }

#pragma mark Conforms to <WebFrameLoadDelegate>
- ( void )        webView: ( WebView* )_WebView
    didFinishLoadForFrame: ( WebFrame* )_Frame
    {
    NSError* error = nil;

    if ( _Frame == [ _WebView mainFrame ] )
        {
        if ( _WebView == self->_backingWebView )
            {
            PWWikiPageArchive* castratedWikiPageArchive = nil;

            NSURL* archiveURL =
                [ [ PWCastrateFactory defaultFactory ] castrateFrameOnDisk: _Frame error: &error archive: &castratedWikiPageArchive ];

            if ( !error )
                {
                [ self->_wikiEngine searchAllPagesThatHaveValue: castratedWikiPageArchive.wikiPageTitle
                                                   inNamespaces: nil
                                                           what: WikiEngineSearchWhatPageText
                                                          limit: 1
                                                        success:
                    ^( NSArray* _MatchedPages )
                        {
                        if ( _MatchedPages )
                            {
                            [ self __saveScrollPosition ];
                            [ self.webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: archiveURL ] ];

                            // Resume routing navigation action
                            [ self.webView setPolicyDelegate: self ];

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

        else if ( _WebView == self.webView )
            {
            [ self.owner.navButtonsPairView reload ];
            [ self.webView setPolicyDelegate: self ];

            [ self __restoreScrollPosition ];

            #if DEBUG
            NSLog( @">>> (Log:%s) 🌰Current back-forward list:\n{%@\nvs.\n%@}", __PRETTY_FUNCTION__, _debuggingBFList, _backForwardList );
            NSLog( @">>> (Log:%s) 🐣Back Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, _debuggingBFList.backItem, _backForwardList.backItem );
            NSLog( @">>> (Log:%s) 🐣Forward Page:\n{\n%@\nvs.\n%@\n}", __PRETTY_FUNCTION__, _debuggingBFList.forwardItem, _backForwardList.forwardItem );
            #endif
            }
        }
    }

#pragma mark Conforms to <WebPolicyDelegate>

// Routes all the navigation action that occured in self.webView
- ( void )                  webView: ( WebView* )_WebView
    decidePolicyForNavigationAction: ( NSDictionary* )_ActionInformation
                            request: ( NSURLRequest* )_Request
                              frame: ( WebFrame* )_Frame
                   decisionListener: ( id <WebPolicyDecisionListener> )_Listener
    {
    if ( _WebView == self.webView )
        {
        // Pause routing navigation action to avoid the infinite recursion
        [ self.webView setPolicyDelegate: nil ];

        if ( [ _Request.URL.scheme isEqualToString: @"file" ] )
            [ _Listener use ];
        else
            {
            [ self->_backingWebView.mainFrame loadRequest: _Request ];
            [ _Listener ignore ];
            }
        }
    }

#pragma mark Private Interfaces
- ( void ) __saveScrollPosition
    {
    NSString* xOffset = [ self.webView stringByEvaluatingJavaScriptFromString: [ NSString stringWithFormat:@"window.pageXOffset" ] ];
    NSString* yOffset = [ self.webView stringByEvaluatingJavaScriptFromString: [ NSString stringWithFormat:@"window.pageYOffset" ] ];

    [ self->_backForwardList.currentItem setXOffset: xOffset.doubleValue ];
    [ self->_backForwardList.currentItem setYOffset: yOffset.doubleValue ];
    }

- ( void ) __restoreScrollPosition
    {
    [ self.webView stringByEvaluatingJavaScriptFromString:
        [ NSString stringWithFormat:@"window.scrollTo( %g, %g )", self->_backForwardList.currentItem.xOffset, self->_backForwardList.currentItem.yOffset ] ];
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