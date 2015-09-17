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

#import "__PWSearchResultSnippetBackingTextView.h"

#import "NSColor+TKSafariSearchbar.h"

// __PWSearchResultSnippetBackingTextView class
@implementation __PWSearchResultSnippetBackingTextView

- ( instancetype ) initWithFrame: ( NSRect )_Frame
                   textContainer: ( NSTextContainer* )_TextContainer
                        delegate: ( id <NSTextViewDelegate> )_Delegate
    {
    if ( self = [ super initWithFrame: _Frame textContainer: _TextContainer ] )
        {
        [ self setDelegate: _Delegate ];

        [ self setLinkTextAttributes: @{ NSForegroundColorAttributeName : [ NSColor colorWithHTMLColor: @"4ebbf1" ] } ];

        [ self setEditable: NO ];
        [ self setBackgroundColor: [ NSColor clearColor ] ];
        [ self configureForAutoLayout ];
        }

    return self;
    }

#pragma mark Overrides
- ( NSRange ) selectionRangeForProposedRange: ( NSRange )_ProposedSelRange
                                 granularity: ( NSSelectionGranularity )_Granularity
    {
    return NSMakeRange( 0, 0 );
    }

@end // __PWSearchResultSnippetBackingTextView class

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