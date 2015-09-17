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

#import "PWSearchResultTitleField.h"

#import "SugarWiki.h"

// PWSearchResultTitleField class
@implementation PWSearchResultTitleField

@dynamic wikiSearchResult;

#pragma mark Initializations
+ ( instancetype ) titleFieldWithFrame: ( NSRect )_Frame
                      wikiSearchResult: ( WikiSearchResult* )_Result;
    {
    return [ [ self alloc ] initWithFrame: _Frame wikiSearchResult: _Result ];
    }

- ( instancetype ) initWithFrame: ( NSRect )_Frame
                wikiSearchResult: ( WikiSearchResult* )_Result;
    {
    if ( self = [ super initWithFrame: _Frame ] )
        {
        self->__attrs = @{ NSFontNameAttribute : [ NSFont fontWithName: @"Helvetica Neue" size: 15.f ]
                         , NSForegroundColorAttributeName : [ NSColor blackColor ]
                         };

        [ self setWikiSearchResult: _Result ];
        }

    return self;
    }

#pragma mark Dynamic Properties
- ( void ) setWikiSearchResult: ( WikiSearchResult* )_Result
    {
    if ( _Result && _Result != self->__wikiSearchResult )
        {
        self->__wikiSearchResult = _Result;

        NSSize size = [ self->__wikiSearchResult.title sizeWithAttributes: self->__attrs ];
        NSRect rect = NSMakeRect( 0.f, 0.f, size.width, size.height );
        [ self->__wikiSearchResult.title drawInRect: rect withAttributes: self->__attrs ];
        }
    }

- ( WikiSearchResult* ) wikiSearchResult
    {
    return self->__wikiSearchResult;
    }

@end // PWSearchResultTitleField class

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