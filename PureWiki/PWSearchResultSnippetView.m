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
  ██████████████████████████████████████████████████████████████████████████████*/

#import "PWSearchResultSnippetView.h"
#import "PWActionNotifications.h"

#import "PWSearchResultSnippetBackingTextView.h"

#import "SugarWiki.h"

// Private Interfaces
@interface PWSearchResultSnippetView ()
- ( NSXMLNode* ) __processedResultSnippetHTML: ( NSXMLElement* )_NSHTML;
@end // Private Interfaces

// PWSearchResultSnippetView class
@implementation PWSearchResultSnippetView

@dynamic wikiSearchResult;

@dynamic backingTextView;

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
- ( PWSearchResultSnippetBackingTextView* ) backingTextView
    {
    return ( PWSearchResultSnippetBackingTextView* )
        self->__internalTextStorage.layoutManagers.firstObject
                                   .textContainers.firstObject
                                   .textView;
    }

- ( void ) setWikiSearchResult: ( WikiSearchResult* )_Result
    {
    self->__wikiSearchResult = _Result;

    NSString* HTMLString = [ [ self __processedResultSnippetHTML: _Result.resultSnippet ] XMLString ];

    NSData* HTMLData = [ HTMLString dataUsingEncoding: NSUTF8StringEncoding ];
    self->__internalTextStorage = [ [ NSTextStorage alloc ] initWithHTML: HTMLData documentAttributes: nil ];

    [ self->__internalTextStorage addAttribute: NSCursorAttributeName
                                         value: [ NSCursor arrowCursor ]
                                         range: NSMakeRange( 0, self->__internalTextStorage.length ) ];

    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];
    [ self->__internalTextStorage addLayoutManager: layoutManager ];

    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: self.frame.size ];

    // textContainer should follow changes to the width of its text view
    [ textContainer setWidthTracksTextView: YES ];
    // textContainer should follow changes to the height of its text view
    [ textContainer setHeightTracksTextView: YES ];

    [ layoutManager addTextContainer: textContainer ];

    ( void )[ [ PWSearchResultSnippetBackingTextView alloc ] initWithFrame: self.frame textContainer: textContainer delegate: self ];

    [ self setSubviews: @[ self.backingTextView ] ];
    [ self.backingTextView autoPinEdgesToSuperviewEdges ];
    }

- ( BOOL ) textView: ( NSTextView* )_TextView
      clickedOnLink: ( id )_Link
            atIndex: ( NSUInteger )_CharIndex
    {
    BOOL isHandled = NO;
    if ( [ _Link isKindOfClass: [ NSURL class ] ] )
        {
        [ [ NSNotificationCenter defaultCenter ] postNotificationName: PureWikiDidPickUpSearchItemNotif
                                                               object: self
                                                             userInfo: @{ kSearchResult : self->__wikiSearchResult
                                                                        , kMoreLink : ( NSURL* )_Link
                                                                        } ];
        isHandled = YES;
        }

    return isHandled;
    }

- ( WikiSearchResult* ) wikiSearchResult
    {
    return self->__wikiSearchResult;
    }

#pragma mark Private Interfaces

NSString static* const sResultSnippetContentCSS =
    @"body {"
        "font-family: \"Helvetica Neue\";"
        "color: rgb(10, 10, 10);"
        "font-size: 1.2em;"
        "line-height: 140%;"
        "font-weight: lighter;"
        "}"

    "span.searchmatch {"
        "/*background-color: rgb(235, 240, 29);*/"
        "font-style: italic;"
        "}"

    // To render a "more" link that has a custom color (#4ebbf1) and no underline,
    // below CSS code fregment and linkTextAttributes dictionary of
    // the text view must coexist in the attributed string.
    "#more {"
        "color: rgb( 78, 187, 241 );"
        "font-family: \"Lucida Grande\";"
        "font-size: .9em;"
        "text-decoration: none;"
        "}";

- ( NSXMLNode* ) __processedResultSnippetHTML: ( NSXMLElement* )_NSHTML
    {
    NSError* error = nil;
    NSXMLElement* processedHTML = _NSHTML;

    NSXMLNode* ellipsisTextNode = [ [ NSXMLNode alloc ] initWithKind: NSXMLTextKind ];
    [ ellipsisTextNode setStringValue: @"... " ];
    [ processedHTML addChild: ellipsisTextNode ];

    NSXMLElement* moreLinkNode = [ [ NSXMLElement alloc ] initWithXMLString: @"<a>more</a>" error: &error ];
    [ moreLinkNode setAttributesWithDictionary: @{ @"id" : @"more"
                                                 , @"href" : [ NSString stringWithFormat: @"x-purewiki://search/result/show-more/%@", self->__wikiSearchResult.title ]
                                                 } ];
    [ processedHTML addChild: moreLinkNode ];

    NSXMLElement* rootNode = [ [ NSXMLElement alloc ] initWithName: @"html" ];
    NSXMLElement* headNode = [ [ NSXMLElement alloc ] initWithXMLString: @"<head><meta charset=\"utf-8\" /></head>" error: &error ];
    NSXMLElement* bodyNode = [ [ NSXMLElement alloc ] initWithXMLString: @"<body></body>" error: nil ];
    NSXMLElement* styleNode = [ [ NSXMLElement alloc ] initWithXMLString: [ NSString stringWithFormat: @"<style>%@</style>", sResultSnippetContentCSS ] error: &error ];

    [ bodyNode addChild: processedHTML ];
    [ headNode addChild: styleNode ];
    [ rootNode setChildren: @[ headNode, bodyNode ] ];

    NSXMLDocument* wrapingDocument = [ [ NSXMLDocument alloc ] initWithRootElement: rootNode ];
    return wrapingDocument;
    }

@end // PWSearchResultSnippetView class

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