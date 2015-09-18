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
#import "PWOpenedPageContentPreviewView.h"
#import "PWOpenedPageContentPreviewBackingTextView.h"

#import "SugarWiki.h"

// Private Interfaces
@interface PWSidebarTabsTableCell ()

- ( void ) __relayout;

@end // Private Interfaces

// PWSidebarTabsTableCell class
@implementation PWSidebarTabsTableCell

@dynamic openedWikiPage;

- ( void ) awakeFromNib
    {
    [ self removeAllConstraints ];
    }

#pragma mark Dynamic Properties
- ( void ) setOpenedWikiPage: ( PWOpenedWikiPage* )_OpenedWikiPage
    {
    self->_openedWikiPage = _OpenedWikiPage;

    self.pageImageView.wikiPage = self->_openedWikiPage.openedWikiPage;

    self.pageTitleTextField.stringValue = self->_openedWikiPage.openedWikiPage.title ?: @"";

    if ( !self->__openedPageContentPreviewView )
        self->__openedPageContentPreviewView = [ [ PWOpenedPageContentPreviewView alloc ] initWithFrame: self.frame ];

    [ self->__openedPageContentPreviewView setOpenedWikiPage: self->_openedWikiPage ];
    [ self __relayout ];
    }

- ( PWOpenedWikiPage* ) openedWikiPage
    {
    return self->_openedWikiPage;
    }

#pragma mark Private Interfaces
CGFloat kInsetFromLeading = 20.f;
CGFloat kInsetFromTrailing = 5.f;
CGFloat kInsetFromTop = 10.f;
CGFloat kInsetFromBottom = 10.f;

CGFloat kPageTitleFieldMinWidth = 50.f;

CGFloat kOffsetFromPageImageView = 10.f;
CGFloat kOffsetBetweenPageTitleAndSnippetField = 10.f;

- ( void ) __relayout
    {
    #if DEBUG
    self.pageImageView.identifier = @"page-image-view";
    self.pageTitleTextField.identifier = @"page-title-field";
    self->__openedPageContentPreviewView.identifier = @"page-preview-view";
    self->__openedPageContentPreviewView.backingTextView.identifier = @"page-preview-backing-text-view";
    #endif

    [ self.pageImageView configureForAutoLayout ];
    [ self.pageTitleTextField configureForAutoLayout ];

    if ( self->__openedPageContentPreviewView.superview != self )
        [ self addSubview: self->__openedPageContentPreviewView ];

    [ self.pageImageView autoSetDimensionsToSize: self.pageImageView.frame.size ];
    [ self.pageImageView autoPinEdgeToSuperviewEdge: ALEdgeLeading withInset: kInsetFromLeading relation: NSLayoutRelationEqual ];
    [ self.pageImageView autoPinEdgeToSuperviewEdge: ALEdgeTop withInset: kInsetFromTop relation: NSLayoutRelationEqual ];

    [ self.pageTitleTextField autoSetDimension: ALDimensionWidth toSize: kPageTitleFieldMinWidth relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self.pageTitleTextField autoPinEdgeToSuperviewEdge: ALEdgeTop withInset: kInsetFromTop relation: NSLayoutRelationEqual ];
    [ self.pageTitleTextField autoPinEdge: ALEdgeLeft toEdge: ALEdgeRight ofView: self.pageImageView withOffset: kOffsetFromPageImageView ];
    [ self.pageTitleTextField autoPinEdgeToSuperviewEdge: ALEdgeTrailing withInset: kInsetFromTrailing relation: NSLayoutRelationEqual ];

    [ self->__openedPageContentPreviewView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: self.pageTitleTextField ];
    [ self->__openedPageContentPreviewView autoPinEdge: ALEdgeLeft toEdge: ALEdgeRight ofView: self.pageImageView withOffset: kOffsetFromPageImageView ];
    [ self->__openedPageContentPreviewView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self.pageTitleTextField withOffset: kOffsetBetweenPageTitleAndSnippetField ];
    [ self->__openedPageContentPreviewView autoPinEdgeToSuperviewEdge: ALEdgeBottom withInset: kInsetFromBottom relation: NSLayoutRelationEqual ];
    [ self->__openedPageContentPreviewView autoPinEdgeToSuperviewEdge: ALEdgeTrailing withInset: kInsetFromTrailing relation: NSLayoutRelationEqual ];
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