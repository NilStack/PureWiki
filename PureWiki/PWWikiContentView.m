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
        {
        self->_backingWebView = [ [ WebView alloc ] initWithFrame: NSMakeRect( 0.f, 0.f, 1.f, 1.f ) frameName: nil groupName: nil ];
        [ self->_backingWebView setFrameLoadDelegate: self ];
        }

    return self;
    }

#pragma mark Dynamic Properties
- ( void ) setWikiPage: ( WikiPage* )_WikiPage
    {
    if ( self->_wikiPage != _WikiPage )
        {
        self->_wikiPage = _WikiPage;

        [ self->_backingWebView.mainFrame stopLoading ];

        NSURLRequest* request = [ NSURLRequest requestWithURL: self->_wikiPage.URL ];
        [ self->_backingWebView.mainFrame loadRequest: request ];
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
    if ( _Frame == [ _WebView mainFrame ] )
        {
        WebArchive* castratedArchive = [ [ PWCastrateFactory defaultFactory ] castrateFrame: _Frame ];
        [ self.webView.mainFrame loadArchive: castratedArchive ];
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