//
//  PWSidebarTabsTableController.m
//  PureWiki
//
//  Created by Tong G. on 8/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWSidebarTabsTableController.h"
#import "PWActionNotifications.h"
#import "PWSidebarTabsTable.h"
#import "WikiPage.h"

NSString* const kColumnIdentifierTabs = @"tabs-column";

// Private Interfaces
@interface PWSidebarTabsTableController ()

- ( void ) _didSearchSearchPages: ( NSNotification* )_Notif;

@end // Private Interfaces

// PWSidebarTabsTableController class
@implementation PWSidebarTabsTableController

- ( instancetype ) initWithCoder: ( nonnull NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->_openedWikiPages = [ NSMutableArray array ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _didSearchSearchPages: )
                                                        name: PureWikiDidSearchPagesNotif
                                                      object: nil ];
        }

    return self;
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: PureWikiDidSearchPagesNotif object: nil ];
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
    NSView* resultView = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];
    WikiPage* wikiPage = [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ];
    [ [ ( NSTableCellView* )resultView textField ] setStringValue: wikiPage.title ];

    return resultView;
    }

#pragma mark Private Interfaces
- ( void ) _didSearchSearchPages: ( NSNotification* )_Notif
    {
    NSArray* matchedPages = _Notif.userInfo[ kPages ];

    if ( matchedPages )
        {
        [ self->_openedWikiPages addObjectsFromArray: matchedPages ];
        [ self.sidebarTabsTable reloadData ];
        }
    }

@end // PWSidebarTabsTableController class