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

CGFloat static const kLeadingGap = 4.f;
CGFloat static const kTrailingGap = 20.f;

// PWSearchResultTitleField class
@implementation PWSearchResultTitleField

@dynamic wikiSearchResult;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->__attrs = @{ NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue" size: 17.f ]
                         , NSForegroundColorAttributeName : [ NSColor blackColor ]
                         };

//        NSString* testChar = @"a";
//        NSMutableString* testTitle = [ NSMutableString stringWithString: testChar ];
//        self->__maxTitleCharCount = testTitle.length;
//
//        CGFloat maxTitleWidth = NSWidth( self.bounds ) - kTrailingGap;
//        CGFloat widthOfCurrentTitleCharCount = [ testTitle sizeWithAttributes: self->__attrs ].width;
//
//        while ( widthOfCurrentTitleCharCount < maxTitleWidth )
//            {
//            [ testTitle appendString: testChar ];
//            widthOfCurrentTitleCharCount = [ testTitle sizeWithAttributes: self->__attrs ].width;
//            self->__maxTitleCharCount++;
//            }

        self->__maxTitleCharCount = 47;
        }

    return self;
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSString* drawingContent = self->__wikiSearchResult.title;
    NSDictionary* drawingAttrs = self->__attrs;

    if ( drawingContent.length > self->__maxTitleCharCount )
        {
        drawingContent = [ drawingContent substringToIndex: self->__maxTitleCharCount - 3 - 1 ];
        drawingContent = [ drawingContent stringByAppendingString: @"..." ];
        }

    NSSize occupiedSize = [ drawingContent sizeWithAttributes: drawingAttrs ];
    NSRect occupiedRect = NSMakeRect( kLeadingGap
                                    , ( NSHeight( self.bounds ) - occupiedSize.height ) / 2.f
                                    , occupiedSize.width
                                    , NSHeight( self.bounds )
                                    );

    [ drawingContent drawInRect: occupiedRect withAttributes: drawingAttrs ];

    NSBezierPath* cuttingLinePath = [ NSBezierPath bezierPath ];
    CGFloat cuttingLineY = ( NSHeight( self.bounds ) - 1.f ) / 2.f - 2.5f;
    [ cuttingLinePath moveToPoint: NSMakePoint( occupiedSize.width + 15.f, cuttingLineY ) ];
    [ cuttingLinePath lineToPoint: NSMakePoint( NSMaxX( self.bounds ) - 4.f, cuttingLineY ) ];

    [ [ [ NSColor grayColor ] colorWithAlphaComponent: .2f ] setStroke ];
    [ cuttingLinePath stroke ];
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