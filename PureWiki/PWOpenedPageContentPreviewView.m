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

#import "NSXMLNode+PWOpenedPagePreview.h"

#import "SugarWiki.h"

// Private Interfaces
@interface PWOpenedPageContentPreviewView ()
- ( NSXMLDocument* ) __processedTheFuckingHTMLDocument: ( NSXMLDocument* )_HTMLDoc;
@end // Private Interfaces

// PWOpenedPageContentPreviewView class
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
    self->__openedWikiPage = _OpenedWikiPage;

    NSXMLDocument* prettyParsedSnippet =
        [ self __processedTheFuckingHTMLDocument: self->__openedWikiPage.openedWikiPage.lastRevision.prettyParsedSnippet ];
        
    NSData* HTMLData = [ prettyParsedSnippet.XMLString dataUsingEncoding: NSUTF8StringEncoding ];
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

NSString static* const sPagePreviewContentCSS =
@"  body {"
"       font-family: \"Helvetica Neue\";"
"       color: rgb(10, 10, 10);"
"       font-size: 1em;"
"       line-height: 130%;"
"       font-weight: lighter;"
"       }"

"   strong, b {"
"       color: rgb(0, 0, 0);"
"       font-weight: normal;"
"       }"

"     a {"
"       text-decoration: none;"
"       color: rgb(10, 10, 10);"
"       }";

NSString static* const sNoPreviewCSS =
@"    i {"
"       font-style: italic;"
"       font-family: \"Helvetica Neue\";"
"       color: rgb(80, 80, 80);"
"       font-size: 1em;"
"       line-height: 130%;"
"       font-weight: regular;"
"       }";


#pragma mark Private Interfaces
- ( NSXMLDocument* ) __processedTheFuckingHTMLDocument: ( NSXMLDocument* )_HTMLDoc
    {
    NSXMLDocument* processedDoc = nil;
    NSString* css = nil;

    NSXMLElement* bodyElement = [ _HTMLDoc.rootElement elementsForName: @"body" ].firstObject;
    if ( _HTMLDoc && ( bodyElement.childCount > 0 ) )
        {
        processedDoc = _HTMLDoc;
        css = sPagePreviewContentCSS;
        }
    else
        {
        processedDoc = [ [ NSXMLDocument alloc ] initWithXMLString: @"<i style=\"font-family: \"Helvetica Neue\";\">No Preview</i>"
                                                           options: NSXMLDocumentTidyHTML
                                                             error: nil ];
        css = sNoPreviewCSS;
        }

        NSXMLNode* currentNode = processedDoc;
        NSXMLElement* styleNode = [ [ NSXMLElement alloc ] initWithXMLString: [ NSString stringWithFormat: @"<style>%@</style>", css ] error: nil ];

           do
            {
            if ( currentNode.isHeadElement )
                {
                [ ( NSXMLElement* )currentNode addChild: styleNode ];
                break;
                }

            } while ( ( currentNode = currentNode.nextNode ) );


        #if DEBUG
        [ _HTMLDoc.XMLString writeToFile: [ NSHomeDirectory() stringByAppendingString: [ NSString stringWithFormat: @"/%@.htm", self->__openedWikiPage.openedWikiPage.title ] ]
                              atomically: YES
                                encoding: NSUTF8StringEncoding
                                   error: nil ];
        #endif

    return processedDoc;
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