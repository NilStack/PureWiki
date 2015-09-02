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

#import "PWSidebarTabsTableController.h"
#import "PWSidebarTabsTable.h"
#import "PWSidebarTabsTableCell.h"
#import "PWActionNotifications.h"
#import "PWActionNotifications.h"
#import "PWWikiContentView.h"
#import "PWOpenedWikiPage.h"

#import "WikiPage.h"

NSString* const PWSidebarCurrentSelectedPageKVOPath = @"currentSelectedPage";

NSString* const kColumnIdentifierTabs = @"tabs-column";

// Private Interfaces
@interface PWSidebarTabsTableController ()

//- ( void ) _userDidPickUpSearchItem: ( NSNotification* )_Notif;
- ( void ) _wikiContentViewWillNavigate: ( NSNotification* )_Notif;

@end // Private Interfaces

// PWSidebarTabsTableController class
@implementation PWSidebarTabsTableController

@dynamic currentSelectedPage;

- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->_openedWikiPages = [ NSMutableArray array ];

//        [ [ NSNotificationCenter defaultCenter ] addObserver: self
//                                                    selector: @selector( _userDidPickUpSearchItem: )
//                                                        name: PureWikiDidPickUpSearchItemNotif
//                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _wikiContentViewWillNavigate: )
                                                        name: PureWikiContentViewWillNavigateNotif
                                                      object: nil ];
        }

    return self;
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: PureWikiDidPickUpSearchItemNotif object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: PureWikiContentViewWillNavigateNotif object: nil ];
    }

#pragma mark Handling Data Source
- ( void ) pushOpenedWikiPage: ( PWOpenedWikiPage* )_OpendedWikiPage
    {
    if ( _OpendedWikiPage )
        {
        NSUInteger index = [ self->_openedWikiPages indexOfObject: _OpendedWikiPage ];

        if ( index == NSNotFound )
            [ self->_openedWikiPages addObject: _OpendedWikiPage ];
        else
            {
            PWOpenedWikiPage* opendedWikiPage = self->_openedWikiPages[ index ];
            if ( opendedWikiPage.currentOpenedWikiPage != _OpendedWikiPage.currentOpenedWikiPage )
                {
                opendedWikiPage.currentOpenedWikiPage = _OpendedWikiPage.currentOpenedWikiPage;
                [ self.sidebarTabsTable reloadData ];
                }
            }

        [ self.sidebarTabsTable reloadData ];
        NSIndexSet* selectRowIndexes = [ NSIndexSet indexSetWithIndex: self->_openedWikiPages.count - 1 ];
        [ self.sidebarTabsTable selectRowIndexes: selectRowIndexes byExtendingSelection: NO ];
        }
    }

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( nonnull NSTableView* )_TableView
    {
    return self->_openedWikiPages.count;
    }

- ( id )            tableView: ( nonnull NSTableView* )_TableView
    objectValueForTableColumn: ( nullable NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: kColumnIdentifierTabs ] )
        result = self->_openedWikiPages[ _Row ];

    return result;
    }

#pragma mark Conforms to <NSTableViewDelegate>
- ( NSView* ) tableView: ( nonnull NSTableView* )_TableView
     viewForTableColumn: ( nullable NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    PWSidebarTabsTableCell* resultCellView = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];
    PWOpenedWikiPage* opendedWikiPage = [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ];
    [ resultCellView setWikiPage: opendedWikiPage.currentOpenedWikiPage ];

    return resultCellView;
    }

- ( void ) tableViewSelectionDidChange: ( nonnull NSNotification* )_Notification
    {
    NSInteger selectedRowIndex = self.sidebarTabsTable.selectedRow;
    
    [ self willChangeValueForKey: PWSidebarCurrentSelectedPageKVOPath ];
        self->_currentSelectedPage = self->_openedWikiPages[ selectedRowIndex ];
    [ self didChangeValueForKey: PWSidebarCurrentSelectedPageKVOPath ];
    }

#pragma mark Dynamic Properties
- ( PWOpenedWikiPage* ) currentSelectedPage
    {
    return self->_currentSelectedPage;
    }

//#pragma mark Private Interfaces
//- ( void ) _userDidPickUpSearchItem: ( NSNotification* )_Notif
//    {
//    WikiPage* wikiPage = _Notif.userInfo[ kPage ];
//    [ self->_openedWikiPages addObject: wikiPage ];
//    [ self.sidebarTabsTable reloadData ];
//
//    NSIndexSet* selectRowIndexes = [ NSIndexSet indexSetWithIndex: self->_openedWikiPages.count - 1 ];
//    [ self.sidebarTabsTable selectRowIndexes: selectRowIndexes byExtendingSelection: NO ];
//    }

- ( void ) _wikiContentViewWillNavigate: ( NSNotification* )_Notif
    {
    NSLog( @"🍌%@", _Notif );
    }

@end // PWSidebarTabsTableController class

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