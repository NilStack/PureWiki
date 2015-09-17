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

#import "SugarWiki.h"

// Private Interfaces
@interface PWSearchResultSnippetView ()
- ( NSXMLNode* ) __processedResultSnippetHTML: ( NSXMLElement* )_NSHTML;
@end // Private Interfaces

// PWSearchResultSnippetView class
@implementation PWSearchResultSnippetView

@dynamic wikiSearchResult;

@dynamic repTextView;

#pragma mark Dynamic Properties
- ( NSTextView* ) repTextView
    {
    return self->__internalTextStorage.layoutManagers
                                      .firstObject
                                      .textContainers
                                      .firstObject
                                      .textView;
    }

- ( void ) setWikiSearchResult: ( WikiSearchResult* )_Result
    {
    self->__wikiSearchResult = _Result;

    NSString* HTMLString = [ [ self __processedResultSnippetHTML: _Result.resultSnippet ] XMLString ];

    NSData* HTMLData = [ HTMLString dataUsingEncoding: NSUTF8StringEncoding ];
    NSURL* baseURL = [ NSURL URLWithString: @"http://en.wikipedia.org" ];
    self->__internalTextStorage =
        [ [ NSTextStorage alloc ] initWithHTML: HTMLData baseURL: baseURL/*_BaseURL*/ documentAttributes: nil ];

    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];
    [ self->__internalTextStorage addLayoutManager: layoutManager ];

    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: self.frame.size ];

    // textContainer should follow changes to the width of its text view
    [ textContainer setWidthTracksTextView: YES ];
    // textContainer should follow changes to the height of its text view
    [ textContainer setHeightTracksTextView: YES ];

    [ layoutManager addTextContainer: textContainer ];

    ( void )[ [ NSTextView alloc ] initWithFrame: self.frame textContainer: textContainer ];
    [ self.repTextView setEditable: NO ];
    [ self.repTextView setSelectable: NO ];
    [ self.repTextView setBackgroundColor: [ NSColor clearColor ] ];
    [ self.repTextView configureForAutoLayout ];

    [ self setSubviews: @[ self.repTextView ] ];
    [ self.repTextView autoPinEdgesToSuperviewEdges ];
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
     "}";

- ( NSXMLNode* ) __processedResultSnippetHTML: ( NSXMLElement* )_NSHTML
    {
    NSError* error = nil;
    NSXMLElement* processedHTML = _NSHTML;

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