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
#import "PWOpenedPagePreviewTitleField.h"
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
@dynamic isHostRowViewSelected;

- ( void ) awakeFromNib
    {
    [ self removeAllConstraints ];
    }

#pragma mark Dynamic Properties
- ( void ) setOpenedWikiPage: ( PWOpenedWikiPage* )_OpenedWikiPage
    {
    self->_openedWikiPage = _OpenedWikiPage;

    self.pageImageView.wikiPage = self->_openedWikiPage.openedWikiPage;

    if ( !self->__openedPageContentPreivewTitleField )
        self->__openedPageContentPreivewTitleField = [ [ PWOpenedPagePreviewTitleField alloc ] initWithFrame: self.frame ];

    if ( !self->__openedPageContentPreviewView )
        self->__openedPageContentPreviewView = [ [ PWOpenedPageContentPreviewView alloc ] initWithFrame: self.frame ];

    [ self->__openedPageContentPreivewTitleField setOpenedWikiPage: self->_openedWikiPage ];
    [ self->__openedPageContentPreviewView setOpenedWikiPage: self->_openedWikiPage ];
    [ self __relayout ];
    }

- ( PWOpenedWikiPage* ) openedWikiPage
    {
    return self->_openedWikiPage;
    }

#pragma mark Conforms to <PWSubviewOfSidebarTableRowView>
- ( void ) setHostRowViewSelected: ( BOOL )_YesOrNo
    {
    if ( self->__isHostRowViewSelected != _YesOrNo )
        {
        self->__isHostRowViewSelected = _YesOrNo;
        NSLog( @"%@", self->__isHostRowViewSelected ? @"✅" : @"❌" );

        [ self->__openedPageContentPreivewTitleField setHostRowViewSelected: self->__isHostRowViewSelected ];
        }
    }

- ( BOOL ) isHostRowViewSelected
    {
    return self->__isHostRowViewSelected;
    }

#pragma mark Private Interfaces
CGFloat kInsetFromLeading = 20.f;
CGFloat kInsetFromTrailing = 5.f;
CGFloat kInsetFromTop = 10.f;
CGFloat kInsetFromBottom = 10.f;

CGFloat kPageTitleFieldMinWidth = 50.f;

CGFloat kOffsetFromPageImageView = 10.f;
CGFloat kOffsetBetweenPageTitleAndSnippetField = 5.f;

- ( void ) __relayout
    {
    #if DEBUG
    self.pageImageView.identifier = @"page-image-view";
    self->__openedPageContentPreivewTitleField.identifier = @"page-preview-title-field";
    self->__openedPageContentPreviewView.identifier = @"page-preview-view";
    self->__openedPageContentPreviewView.backingTextView.identifier = @"page-preview-backing-text-view";
    #endif

    [ self.pageImageView configureForAutoLayout ];

    if ( self->__openedPageContentPreivewTitleField.superview != self )
        [ self addSubview: self->__openedPageContentPreivewTitleField ];

    if ( self->__openedPageContentPreviewView.superview != self )
        [ self addSubview: self->__openedPageContentPreviewView ];

    [ self.pageImageView autoSetDimensionsToSize: self.pageImageView.frame.size ];
    [ self.pageImageView autoPinEdgeToSuperviewEdge: ALEdgeLeading withInset: kInsetFromLeading relation: NSLayoutRelationEqual ];
    [ self.pageImageView autoPinEdgeToSuperviewEdge: ALEdgeTop withInset: kInsetFromTop relation: NSLayoutRelationEqual ];

    [ self->__openedPageContentPreivewTitleField autoSetDimension: ALDimensionHeight toSize: 24.f relation: NSLayoutRelationEqual ];
    [ self->__openedPageContentPreivewTitleField autoSetDimension: ALDimensionWidth toSize: kPageTitleFieldMinWidth relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self->__openedPageContentPreivewTitleField autoPinEdgeToSuperviewEdge: ALEdgeTop withInset: kInsetFromTop relation: NSLayoutRelationEqual ];
    [ self->__openedPageContentPreivewTitleField autoPinEdge: ALEdgeLeft toEdge: ALEdgeRight ofView: self.pageImageView withOffset: kOffsetFromPageImageView ];
    [ self->__openedPageContentPreivewTitleField autoPinEdgeToSuperviewEdge: ALEdgeTrailing withInset: kInsetFromTrailing relation: NSLayoutRelationEqual ];

    [ self->__openedPageContentPreviewView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: self->__openedPageContentPreivewTitleField ];
    [ self->__openedPageContentPreviewView autoPinEdge: ALEdgeLeft toEdge: ALEdgeRight ofView: self.pageImageView withOffset: kOffsetFromPageImageView ];
    [ self->__openedPageContentPreviewView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self->__openedPageContentPreivewTitleField withOffset: kOffsetBetweenPageTitleAndSnippetField ];
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