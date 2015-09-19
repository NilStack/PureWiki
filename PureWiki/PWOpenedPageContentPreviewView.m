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
    self->__openedWikiPage = _OpenedWikiPage;

    NSXMLDocument* HTMLDocument = [ [ NSXMLDocument alloc ] initWithXMLString: self->__openedWikiPage.openedWikiPage.lastRevision.content
                                                                      options: NSXMLDocumentTidyHTML
                                                                        error: nil ];

    [ self __processedTheFuckingHTMLDocument: HTMLDocument ];
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

NSString static* const sPagePreviewContentCSS =
    @"body {"
        "font-family: \"Helvetica Neue\";"
        "color: rgb(10, 10, 10);"
        "font-size: 1em;"
        "line-height: 130%;"
        "font-weight: lighter;"
        "}"

    "strong, b {"
        "color: rgb(0, 0, 0);"
        "font-weight: normal;"
        "}"

    " a {"
        "text-decoration: none;"
        "color: rgb(10, 10, 10);"
        "}";

- ( BOOL ) __isNodeHeadElement: ( NSXMLNode* )_Node
    {
    if ( _Node.kind == NSXMLElementKind && [ _Node.name isEqualToString: @"head" ] )
        return YES;

    return NO;
    }

- ( BOOL ) __isNodeComplicated: ( NSXMLNode* )_Node
    {
    if ( [ _Node.name isEqualToString: @"h1" ]
            || [ _Node.name isEqualToString: @"h2" ]
            || [ _Node.name isEqualToString: @"h3" ]
            || [ _Node.name isEqualToString: @"h4" ]
            || [ _Node.name isEqualToString: @"h5" ]
            || [ _Node.name isEqualToString: @"div" ]
            || [ _Node.name isEqualToString: @"sup" ]
            || [ _Node.name isEqualToString: @"table" ]
            || [ _Node.name isEqualToString: @"dl" ]

            || ( [ _Node.name isEqualToString: @"p" ]
                    && ( _Node.nextNode.kind == NSXMLTextKind )
                    && [ _Node.nextNode.stringValue isEqualToString: @"\n" ] )

            || ( [ _Node.name isEqualToString: @"p" ]
                    && ( _Node.childCount == 0 ) ) )
        return YES;

    return NO;
    }

- ( BOOL ) __isNodeCoordinates: ( NSXMLNode* )_Node
    {
    if ( _Node.kind == NSXMLElementKind && [ _Node.name isEqualToString: @"span" ] )
        {
        __SugarArray_of( NSXMLNode* ) attrs = [ ( NSXMLElement* )_Node attributes ];

        for ( NSXMLNode* _Attr in attrs )
            if ( [ _Attr.stringValue isEqualToString: @"coordinates" ] )
                return YES;
        }

    return NO;
    }

- ( void ) __processedTheFuckingHTMLDocument: ( NSXMLDocument* )_HTMLDoc
    {
    NSMutableArray* toBeCastrated = [ NSMutableArray array ];

    NSXMLNode* currentNode = _HTMLDoc;
    NSXMLElement* styleNode = [ [ NSXMLElement alloc ] initWithXMLString: [ NSString stringWithFormat: @"<style>%@</style>", sPagePreviewContentCSS ] error: nil ];

       do
        {
        if ( [ self __isNodeHeadElement: currentNode ] )
            [ ( NSXMLElement* )currentNode addChild: styleNode ];

        if ( [ self __isNodeComplicated: currentNode ]
                || [ self __isNodeCoordinates: currentNode ] )
            [ toBeCastrated addObject: currentNode ];

        } while ( ( currentNode = currentNode.nextNode ) );

    for ( int _Index = 0; _Index < toBeCastrated.count; _Index++ )
        {
        NSXMLNode* depNode = toBeCastrated[ _Index ];
        if ( depNode.parent.childCount == 1 )
            {
            [ toBeCastrated removeObject: depNode ];
            [ toBeCastrated addObject: depNode.parent ];
            }
        }

    [ toBeCastrated makeObjectsPerformSelector: @selector( detach ) ];

    #if DEBUG
    [ _HTMLDoc.XMLString writeToFile: [ NSHomeDirectory() stringByAppendingString: [ NSString stringWithFormat: @"/%@.htm", self->__openedWikiPage.openedWikiPage.title ] ]
                          atomically: YES
                            encoding: NSUTF8StringEncoding
                               error: nil ];
    #endif
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