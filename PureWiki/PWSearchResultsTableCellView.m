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
#import "PWSearchResultSnippetTextStorage.h"

#import "SugarWiki.h"
#import "PureLayout.h"

// PWSearchResultsTableCellView class
@implementation PWSearchResultsTableCellView

@dynamic wikiSearchResult;

- ( void ) awakeFromNib
    {
    self->__searchResultSnippetTextStorage =
        [ [ PWSearchResultSnippetTextStorage alloc ] initWithContainerFrame: self.bounds ];
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    
    // Drawing code here.
    }

#pragma mark Handling Events
- ( void ) mouseDown: ( nonnull NSEvent* )_Event
    {
    [ super mouseDown: _Event ];

    [ [ NSNotificationCenter defaultCenter ] postNotificationName: PureWikiDidPickUpSearchItemNotif
                                                           object: self
                                                         userInfo: @{ kSearchResult : self->_wikiSearchResult } ];
    }

#pragma mark Dynamic Properties
- ( void ) setWikiSearchResult: ( WikiSearchResult* )_SearchResult
    {
    self->_wikiSearchResult = _SearchResult;

    // self.pageImageView =
    self.pageTitleTextField.stringValue = self->_wikiSearchResult.title;
//    self.pageSnippetTextField.stringValue = [ self->_wikiSearchResult resultSnippet ];

    [ self->__searchResultSnippetTextStorage setWikiSearchResult: _SearchResult ];
    [ self __relayout ];
    }

- ( void ) __relayout
    {

    }

- ( WikiSearchResult* ) wikiSearchResult
    {
    return self->_wikiSearchResult;
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