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
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "PWSidebarTabsTableCell.h"
#import "PWPWikiPageImageWell.h"
#import "PWOpenedWikiPage.h"

#import "SugarWiki.h"

// Private Interfaces
@interface PWSidebarTabsTableCell ()

- ( void ) _relayoutAllThings;

@end // Private Interfaces

// PWSidebarTabsTableCell class
@implementation PWSidebarTabsTableCell

@dynamic openedWikiPage;

#pragma mark Initializations
- ( void ) awakeFromNib
    {
    [ self _relayoutAllThings ];
    }

- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        ;

    return self;
    }

#pragma mark Dynamic Properties
- ( void ) setOpenedWikiPage: ( PWOpenedWikiPage* )_OpenedWikiPage
    {
    self->_openedWikiPage = _OpenedWikiPage;

    self.pageImageView.wikiPage = self->_openedWikiPage.openedWikiPage;

    self.pageTitleTextField.stringValue = self->_openedWikiPage.openedWikiPage.title ?: @"";
    self.pageSnippetTextField.stringValue = [ self->_openedWikiPage.openedWikiPage.lastRevision.content substringToIndex: 100 ] ?: @"";
    }

- ( PWOpenedWikiPage* ) openedWikiPage
    {
    return self->_openedWikiPage;
    }

#pragma mark Private Interfaces
CGFloat kInsetFromLeading = 20.f;
CGFloat kInsetFromTrailing = 20.f;
CGFloat kInsetFromTop = 10.f;
CGFloat kInsetFromBottom = 10.f;

CGFloat kPageTitleFieldMinWidth = 50.f;

CGFloat kOffsetFromPageImageView = 10.f;
CGFloat kOffsetBetweenPageTitleAndSnippetField = 10.f;

- ( void ) _relayoutAllThings
    {
    #if DEBUG
    self.pageImageView.identifier = @"page-image-view";
    self.pageTitleTextField.identifier = @"page-title-field";
    self.pageSnippetTextField.identifier = @"page-snippet-field";
    #endif

    [ self.pageImageView configureForAutoLayout ];
    [ self.pageTitleTextField configureForAutoLayout ];
    [ self.pageSnippetTextField configureForAutoLayout ];

    [ self removeAllConstraints ];

    [ self.pageImageView autoSetDimensionsToSize: self.pageImageView.frame.size ];
    [ self.pageImageView autoPinEdgeToSuperviewEdge: ALEdgeLeft withInset: kInsetFromLeading relation: NSLayoutRelationEqual ];
    [ self.pageImageView autoPinEdgeToSuperviewEdge: ALEdgeTop withInset: kInsetFromTop relation: NSLayoutRelationEqual ];

    [ self.pageTitleTextField autoSetDimension: ALDimensionHeight toSize: NSHeight( self.pageTitleTextField.frame ) ];
    [ self.pageTitleTextField autoSetDimension: ALDimensionWidth toSize: kPageTitleFieldMinWidth relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self.pageTitleTextField autoPinEdgeToSuperviewEdge: ALEdgeTop withInset: kInsetFromTop relation: NSLayoutRelationEqual ];
    [ self.pageTitleTextField autoPinEdge: ALEdgeLeft toEdge: ALEdgeRight ofView: self.pageImageView withOffset: kOffsetFromPageImageView ];
    [ self.pageTitleTextField autoPinEdgeToSuperviewEdge: ALEdgeTrailing withInset: kInsetFromTrailing relation: NSLayoutRelationEqual ];

    [ self.pageSnippetTextField autoSetDimension: ALDimensionHeight toSize: NSHeight( self.pageSnippetTextField.frame ) ];
    [ self.pageSnippetTextField autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: self.pageTitleTextField ];
    [ self.pageSnippetTextField autoPinEdge: ALEdgeLeft toEdge: ALEdgeRight ofView: self.pageImageView withOffset: kOffsetFromPageImageView ];
    [ self.pageSnippetTextField autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self.pageTitleTextField withOffset: kOffsetBetweenPageTitleAndSnippetField ];
    [ self.pageSnippetTextField autoPinEdgeToSuperviewEdge: ALEdgeBottom withInset: kInsetFromBottom relation: NSLayoutRelationEqual ];
    [ self.pageSnippetTextField autoPinEdgeToSuperviewEdge: ALEdgeTrailing withInset: kInsetFromTrailing relation: NSLayoutRelationEqual ];
    }

@end // PWSidebarTabsTableCell class

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