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

#import "PWSearchResultSnippetTextStorage.h"

#import "SugarWiki.h"

// Private Interfaces
@interface PWSearchResultSnippetTextStorage ()
@end // Private Interfaces

// PWSearchResultSnippetTextStorage class
@implementation PWSearchResultSnippetTextStorage

@dynamic wikiSearchResult;

@dynamic repTextView;

#pragma mark Initializations
- ( instancetype ) initWithContainerFrame: ( NSRect )_ContainerFrame
    {
    if ( self = [ super init ] )
        self->__containerFrame = _ContainerFrame;

    return self;
    }

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
//    NSLog( @"🍌Before: %@", _Result.resultSnippet );
//    NSString* HTMLString = [ _Result.resultSnippet stringByReplacingOccurrencesOfString: @"\\\"" withString: @"\"" ];
    NSString* HTMLString = _Result.resultSnippet;
//    NSLog( @"After %@", HTMLString );

    NSData* HTMLData = [ HTMLString dataUsingEncoding: NSUTF8StringEncoding ];
    NSURL* baseURL = [ NSURL URLWithString: @"http://en.wikipedia.org" ];
    self->__internalTextStorage =
        [ [ NSTextStorage alloc ] initWithHTML: HTMLData baseURL: baseURL/*_BaseURL*/ documentAttributes: nil ];

    NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];
    [ self->__internalTextStorage addLayoutManager: layoutManager ];

    NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: self->__containerFrame.size ];

    // textContainer should follow changes to the width of its text view
    [ textContainer setWidthTracksTextView: YES ];
    // textContainer should follow changes to the height of its text view
    [ textContainer setHeightTracksTextView: YES ];

    [ layoutManager addTextContainer: textContainer ];

    ( void )[ [ NSTextView alloc ] initWithFrame: self->__containerFrame textContainer: textContainer ];
    [ self.repTextView setEditable: NO ];
    [ self.repTextView setSelectable: NO ];
    [ self.repTextView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    }

- ( WikiSearchResult* ) wikiSearchResult
    {
    return self->__wikiSearchResult;
    }

@end // PWSearchResultSnippetTextStorage class

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