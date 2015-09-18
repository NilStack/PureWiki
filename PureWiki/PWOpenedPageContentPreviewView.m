/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 _______    _             _                 _                 |██
|                (_______)  (_)           | |               | |                |██
|                    _ _ _ _ _ ____   ___ | |  _ _____  ____| |                |██
|                   | | | | | |  _ \ / _ \| |_/ ) ___ |/ ___)_|                |██
|                   | | | | | | |_| | |_| |  _ (| ____| |    _                 |██
|                   |_|\___/|_|  __/ \___/|_| \_)_____)_|   |_|                |██
|                             |_|                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "PWOpenedPageContentPreviewView.h"
#import "PWOpenedWikiPage.h"
#import "PWOpenedPageContentPreviewBackingTextView.h"

#import "SugarWiki.h"

@implementation PWOpenedPageContentPreviewView

@dynamic openedWikiPage;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self configureForAutoLayout ];

    return self;
    }

- ( instancetype ) initWithFrame: ( NSRect )_Frame
    {
    if ( self = [ super initWithFrame: _Frame ] )
        [ self configureForAutoLayout ];

    return self;
    }

#pragma mark Dynamic Properties
- ( PWOpenedPageContentPreviewBackingTextView* ) backingTextView
    {
    return ( PWOpenedPageContentPreviewBackingTextView* )
        self->__internalTextStorage.layoutManagers.firstObject
                                   .textContainers.firstObject
                                   .textView;
    }

- ( void ) setOpenedWikiPage: ( PWOpenedWikiPage* )_OpenedWikiPage
    {
    if ( self->__openedWikiPage == _OpenedWikiPage )
        return;

    self->__openedWikiPage = _OpenedWikiPage;

    NSXMLDocument* HTMLDocument = [ [ NSXMLDocument alloc ] initWithXMLString: self->__openedWikiPage.openedWikiPage.lastRevision.content
                                                                      options: NSXMLDocumentTidyHTML
                                                                        error: nil ];

    NSData* HTMLData = [ HTMLDocument.XMLString dataUsingEncoding: NSUTF8StringEncoding ];
    self->__internalTextStorage = [ [ NSTextStorage alloc ] initWithHTML: HTMLData documentAttributes: nil ];

    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];
    [ self->__internalTextStorage addLayoutManager: layoutManager ];

    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithSize: self.frame.size ];
    [ textContainer setWidthTracksTextView: YES ];
    [ textContainer setHeightTracksTextView: YES ];

    [ layoutManager addTextContainer: textContainer ];

    ( void )[ [ PWOpenedPageContentPreviewBackingTextView alloc ] initWithFrame: self.frame textContainer: textContainer ];

    [ self setSubviews: @[ self.backingTextView ] ];
    [ self.backingTextView configureForAutoLayout ];
    [ self.backingTextView autoPinEdgesToSuperviewEdges ];
    }

- ( PWOpenedWikiPage* ) openedWikiPage
    {
    return self->__openedWikiPage;
    }

@end // PWOpenedPageContentPreviewView class

/*=============================================================================┐
|                                                                              |
|                                        `-://++/:-`    ..                     |
|                    //.                :+++++++++++///+-                      |
|                    .++/-`            /++++++++++++++/:::`                    |
|                    `+++++/-`        -++++++++++++++++:.                      |
|                     -+++++++//:-.`` -+++++++++++++++/                        |
|                      ``./+++++++++++++++++++++++++++/                        |
|                   `++/++++++++++++++++++++++++++++++-                        |
|                    -++++++++++++++++++++++++++++++++`                        |
|                     `:+++++++++++++++++++++++++++++-                         |
|                      `.:/+++++++++++++++++++++++++-                          |
|                         :++++++++++++++++++++++++-                           |
|                           `.:++++++++++++++++++/.                            |
|                              ..-:++++++++++++/-                              |
|                             `../+++++++++++/.                                |
|                       `.:/+++++++++++++/:-`                                  |
|                          `--://+//::-.`                                      |
|                                                                              |
└=============================================================================*/