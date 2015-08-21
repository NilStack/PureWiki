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

@property ( strong, readonly ) NSString* _archivePath;

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

        self->_castrateFactory = [ [ PWCastrateFactory alloc ] init ];
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
        if ( ![ [ NSFileManager defaultManager ] fileExistsAtPath: self._archivePath isDirectory: nil ] )
            [ [ NSFileManager defaultManager ] createDirectoryAtPath: self._archivePath withIntermediateDirectories: NO attributes: nil error: nil ];

        NSString* pageTitle = [ NSString stringWithFormat: @"%@-%@", @( self->_wikiPage.ID ).stringValue, [ NSDate date ] ];
        NSString* base64edPageTitle = [ [ pageTitle dataUsingEncoding: NSUTF8StringEncoding ] base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength ];
        self->_pageArchivePath = [ self._archivePath stringByAppendingPathComponent: [ NSString stringWithFormat: @"/%@.webarchive", base64edPageTitle ] ];

        WebArchive* castratedArchive = [ self->_castrateFactory castrateFrame: _Frame ];
        [ self.webView.mainFrame loadArchive: castratedArchive ];

//        NSError* error = nil;
//        if ( !error )
//            [ castratedArchive.data writeToFile: self->_pageArchivePath options: NSDataWritingAtomic error: &error ];
//        else
//            NSLog( @"error" );
        }
    }

#pragma mark Private Interfaces
@dynamic _archivePath;

- ( NSString* ) _archivePath
    {
    return [ NSHomeDirectory() stringByAppendingPathComponent: [ NSString stringWithFormat: @"/Library/archives" ] ];
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