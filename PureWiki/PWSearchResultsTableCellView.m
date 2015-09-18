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

#import "PWSearchResultsTableCellView.h"
#import "PWActionNotifications.h"
#import "PWSearchResultTitleField.h"
#import "PWSearchResultSnippetView.h"

#import "PWSearchResultSnippetBackingTextView.h"

#import "SugarWiki.h"

CGFloat static const kTopGap = 10.f;
CGFloat static const kBottomGap = 0.f;
CGFloat static const kLeftGap = 20.f;
CGFloat static const kRightGap = kLeftGap;

// Private Interfaces
@interface PWSearchResultsTableCellView ()
- ( void ) __relayout;
@end // Private Interfaces

// PWSearchResultsTableCellView class
@implementation PWSearchResultsTableCellView

@dynamic wikiSearchResult;

#pragma mark Dynamic Properties
- ( void ) setWikiSearchResult: ( WikiSearchResult* )_SearchResult
    {
    if ( self->_wikiSearchResult != _SearchResult )
        {
        self->_wikiSearchResult = _SearchResult;

        if ( !self->__searchResultSnippetTextStorage )
            self->__searchResultSnippetTextStorage = [ [ PWSearchResultSnippetView alloc ] initWithFrame: self.frame ];

        [ self->__searchResultTitleField setWikiSearchResult: self->_wikiSearchResult ];
        [ self->__searchResultSnippetTextStorage setWikiSearchResult: self->_wikiSearchResult ];
        [ self __relayout ];
        }
    }

- ( WikiSearchResult* ) wikiSearchResult
    {
    return self->_wikiSearchResult;
    }

#pragma mark Private Interfaces
- ( void ) __relayout
    {
    [ self->__searchResultTitleField configureForAutoLayout ];

    if ( self->__searchResultSnippetTextStorage.superview != self )
        [ self addSubview: self->__searchResultSnippetTextStorage ];

    NSEdgeInsets snippetInsets = NSEdgeInsetsMake( kTopGap, kLeftGap, kBottomGap, kRightGap );
    [ self->__searchResultTitleField autoPinEdgesToSuperviewEdgesWithInsets: snippetInsets excludingEdge: ALEdgeBottom ];
    [ self->__searchResultSnippetTextStorage autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self->__searchResultTitleField withOffset: kTopGap ];
    [ self->__searchResultSnippetTextStorage autoPinEdgesToSuperviewEdgesWithInsets: snippetInsets excludingEdge: ALEdgeTop ];
    }

@end // PWSearchResultsTableCellView class

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