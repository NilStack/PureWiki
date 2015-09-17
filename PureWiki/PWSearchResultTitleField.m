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

CGFloat const kLeadingGap = 4.f;
CGFloat const kTrailingGap = kLeadingGap;

// PWSearchResultTitleField class
@implementation PWSearchResultTitleField

@dynamic wikiSearchResult;

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSString* drawingContent = self->__wikiSearchResult.title;
    NSDictionary* drawingAttrs = self->__attrs;

    NSSize occupiedSize = [ drawingContent sizeWithAttributes: drawingAttrs ];
    NSRect occupiedRect = NSMakeRect( kLeadingGap, 0.f, occupiedSize.width, NSHeight( self.bounds ) );
    [ self->__wikiSearchResult.title drawInRect: occupiedRect withAttributes: drawingAttrs ];
    }

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->__attrs = @{ NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue" size: 17.f ]
                         , NSForegroundColorAttributeName : [ NSColor blackColor ]
                         };
        }

    return self;
    }

#pragma mark Dynamic Properties
- ( void ) setWikiSearchResult: ( WikiSearchResult* )_Result
    {
    if ( _Result && _Result != self->__wikiSearchResult )
        {
        self->__wikiSearchResult = _Result;
        [ self setNeedsDisplay: YES ];
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