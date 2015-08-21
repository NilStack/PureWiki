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

#import "PWSearchResultsAttachPanelController.h"
#import "PWSearchResultsTableCellView.h"
#import "PWActionNotifications.h"
#import "PWSearchResultsAttachPanel.h"
#import "PWSearchResultsTableView.h"
#import "PWSearchResultsTableCellView.h"

#import "WikiPage.h"
#import "WikiRevision.h"

NSString* const kResultsColumnID = @"results-column";

// Private Interfaces
@interface PWSearchResultsAttachPanelController ()

- ( void ) _didSearchSearchPages: ( NSNotification* )_Notif;
- ( void ) _didEmptySearchContent: ( NSNotification* )_Notif;

@end // Private Interfaces

// PWSearchResultsAttachPanelController class
@implementation PWSearchResultsAttachPanelController

#pragma mark Initializations
+ ( instancetype ) panelController
    {
    return [ [ [ self class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithWindowNibName: @"PWSearchResultsAttachPanel" owner: self ] )
        {
        self->_fetchedWikiPages = [ NSMutableArray array ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _didSearchSearchPages: )
                                                        name: PureWikiDidSearchPagesNotif
                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _didEmptySearchContent: )
                                                        name: PureWikiDidEmptySearchNotif
                                                      object: nil ];
        }

    return self;
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: PureWikiDidSearchPagesNotif object: nil ];
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: PureWikiDidEmptySearchNotif object: nil ];
    }

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( nonnull NSTableView* )_TableView
    {
    return self->_fetchedWikiPages.count;
    }

- ( id )            tableView: ( nonnull NSTableView* )_TableView
    objectValueForTableColumn: ( nullable NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: kResultsColumnID ] )
        result = self->_fetchedWikiPages[ _Row ];

    return result;
    }

#pragma mark Conforms to <NSTableViewDelegate>
- ( NSView* ) tableView: ( nonnull NSTableView* )_TableView
     viewForTableColumn: ( nullable NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    PWSearchResultsTableCellView* tableCellView = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];
    WikiPage* wikiPage = ( WikiPage* )( self->_fetchedWikiPages[ _Row ] );
    [ tableCellView setWikiPage: wikiPage ];

    return tableCellView;
    }

#pragma mark Private Interfaces
- ( void ) _didSearchSearchPages: ( NSNotification* )_Notif
    {
    NSArray* matchedPages = _Notif.userInfo[ kPages ];

    if ( matchedPages )
        {
        [ self->_fetchedWikiPages removeAllObjects ];
        [ self->_fetchedWikiPages addObjectsFromArray: matchedPages ];
        [ self.searchResultsTableView reloadData ];
        }
    }

- ( void ) _didEmptySearchContent: ( NSNotification* )_Notif
    {
    [ self->_fetchedWikiPages removeAllObjects ];
    [ self.searchResultsTableView reloadData ];

    [ self.window close ];
    }

@end // PWSearchResultsAttachPanelController class

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