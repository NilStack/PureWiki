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

#import "WikiSearchResult.h"

// Private Interfaces
@interface PWSearchResultSnippetTextStorage ()
@end // Private Interfaces

// PWSearchResultSnippetTextStorage class
@implementation PWSearchResultSnippetTextStorage

@dynamic wikiSearchResult;

@dynamic repTextView;

#pragma mark Initializations
- ( instancetype ) initWithHTML: ( NSData* )_HTMLData
                        baseURL: ( NSURL* )_BaseURL
             documentAttributes: ( __NSDictionary_of( NSString*, id )* )_DocAttributes
                 containerFrame: ( NSRect )_ContainerFrame
    {
    if ( self = [ super initWithHTML: _HTMLData
                             baseURL: _BaseURL
                  documentAttributes: _DocAttributes ] )
        {
        NSLayoutManager* layoutManager = [ [ NSLayoutManager alloc ] init ];
        [ self addLayoutManager: layoutManager ];

        NSTextContainer* textContainer = [ [ NSTextContainer alloc ] initWithContainerSize: _ContainerFrame.size ];

        // textContainer should follow changes to the width of its text view
        [ textContainer setWidthTracksTextView: YES ];
        // textContainer should follow changes to the height of its text view
        [ textContainer setHeightTracksTextView: YES ];

        [ layoutManager addTextContainer: textContainer ];

        ( void )[ [ NSTextView alloc ] initWithFrame: _ContainerFrame textContainer: textContainer ];
        [ self.repTextView setEditable: NO ];
        [ self.repTextView setSelectable: NO ];
        [ self.repTextView setTranslatesAutoresizingMaskIntoConstraints: NO ];
        }

    return self;
    }

#pragma mark Dynamic Properties
- ( void ) setWikiSearchResult: ( WikiSearchResult* )_Result
    {
    NSLog( @"Before: %@", _Result.resultSnippet );
    NSString* HTMLString = [ _Result.resultSnippet stringByReplacingOccurrencesOfString: @"\\\"" withString: @"\"" ];
    NSLog( @"After %@", HTMLString );

    
    }

- ( WikiSearchResult* ) wikiSearchResult
    {
    return self->__wikiSearchResult;
    }

- ( NSTextView* ) repTextView
    {
    return self.layoutManagers.firstObject.textContainers.firstObject.textView;
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