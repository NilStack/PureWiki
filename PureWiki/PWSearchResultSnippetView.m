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

    NSString* HTMLString = [ _Result.resultSnippet stringByReplacingOccurrencesOfString: @"\\\"" withString: @"\"" ];

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