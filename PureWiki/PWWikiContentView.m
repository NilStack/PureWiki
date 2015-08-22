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

#import "WikiPage.h"

// Private Interfaces
@interface PWWikiContentView ()
@end // Private Interfaces

// PWWikiContentView class
@implementation PWWikiContentView

@dynamic wikiPage;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        self->_backingWebView = [ [ WebView alloc ] initWithFrame: NSMakeRect( 0.f, 0.f, 1.f, 1.f ) frameName: nil groupName: nil ];

    return self;
    }

- ( void ) awakeFromNib
    {
    [ self->_backingWebView setFrameLoadDelegate: self ];
    [ self.webView setPolicyDelegate: self ];
    }

#pragma mark Dynamic Properties
- ( void ) setWikiPage: ( WikiPage* )_WikiPage
    {
    if ( self->_wikiPage != _WikiPage )
        {
        self->_wikiPage = _WikiPage;

        [ self->_backingWebView.mainFrame stopLoading ];

        NSURLRequest* request = [ NSURLRequest requestWithURL: self->_wikiPage.URL ];
        [ self.webView.mainFrame loadRequest: request ];
        }
    }

- ( WikiPage* ) wikiPage
    {
    return self->_wikiPage;
    }

#pragma mark Conforms to <WebFrameLoadDelegate>
- ( void )        webView: ( WebView* )_WebView
    didFinishLoadForFrame: ( WebFrame* )_Frame
    {
    NSError* error = nil;
    if ( _WebView == self->_backingWebView
            && _Frame == [ _WebView mainFrame ] )
        {
        NSURL* archiveURL = [ [ PWCastrateFactory defaultFactory ] castrateFrameOnDisk: _Frame error: &error ];
        if ( !error )
            {
            [ self.webView.mainFrame loadRequest: [ NSURLRequest requestWithURL: archiveURL ] ];

            // Resume routing navigation action
            [ self.webView setPolicyDelegate: self ];

            [ self.owner.goBackButton setEnabled: _WebView.canGoBack ];
            [ self.owner.goForwardButton setEnabled: _WebView.canGoForward ];
            }
        else
            NSLog( @"%@", error );
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

        [ self->_backingWebView.mainFrame loadRequest: _Request ];
        [ _Listener ignore ];
        }
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