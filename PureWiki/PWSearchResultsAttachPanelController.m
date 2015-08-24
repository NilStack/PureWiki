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
#import "WikiEngine.h"

NSString* const kResultsColumnID = @"results-column";

// Private Interfaces
@interface PWSearchResultsAttachPanelController ()

- ( void ) _didSearchPages: ( NSNotification* )_Notif;
- ( void ) _didEmptySearchContent: ( NSNotification* )_Notif;
- ( void ) _mainWindowDidMove: ( NSNotification* )_Notif;

- ( void ) _applicationDidResignActive: ( NSNotification* )_Notif;

// Timer
- ( void ) _timerFireMethod: ( NSTimer* )_Timer;

// Searching
- ( void ) _searchWikiPagesBasedThatHaveValue: ( NSString* )_Value;

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
        self->_instantSearchWikiEngine = [ WikiEngine engineWithISOLanguageCode: @"en" ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _didSearchPages: )
                                                        name: PureWikiDidSearchPagesNotif
                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _didEmptySearchContent: )
                                                        name: PureWikiDidEmptySearchNotif
                                                      object: nil ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _mainWindowDidMove: )
                                                        name: NSWindowDidMoveNotification
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
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _applicationDidResignActive: )
                                                    name: NSApplicationDidResignActiveNotification
                                                  object: nil ];
    }

#pragma mark Controlling The Attach Panel
- ( void ) popUpAttachPanelOnWindow: ( NSWindow* )_ParentWindow
                                  at: ( NSPoint )_PointInScreen
    {
    if ( _ParentWindow )
        {
        [ self.searchResultsAttachPanel setFrameOrigin: _PointInScreen ];
        [ _ParentWindow addChildWindow: self.searchResultsAttachPanel ordered: NSWindowAbove ];
        [ self.searchResultsAttachPanel makeKeyAndOrderFront: nil ];
        }
    }

- ( void ) closeAttachPanel
    {
    [ self stopSearching ];
    [ self.searchResultsAttachPanel.parentWindow removeChildWindow: self.searchResultsAttachPanel ];
    [ self.searchResultsAttachPanel orderOut: self ];
    }

- ( void ) closeAttachPanelAndClearResults
    {
    [ self closeAttachPanel ];
    [ self clearResults ];
    }

#pragma mark Handling Search Results
@dynamic isInUse;

- ( BOOL ) isInUse
    {
    return self->_fetchedWikiPages.count > 0;
    }

- ( void ) stopSearching
    {
    [ self->_instantSearchWikiEngine cancelAll ];
    }

- ( void ) clearResults
    {
    [ self stopSearching ];
    [ self->_fetchedWikiPages removeAllObjects ];
    [ self.searchResultsTableView reloadData ];
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

- ( BOOL ) tableView: ( nonnull NSTableView* )_TableView
     shouldSelectRow: ( NSInteger )_Row
    {
    return NO;
    }

#pragma mark Private Interfaces
- ( void ) _didSearchPages: ( NSNotification* )_Notif
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
    [ self closeAttachPanelAndClearResults ];
    }

- ( void ) _mainWindowDidMove: ( NSNotification* )_Notif
    {
    // NSLog( @"%@", _Notif );
    }

- ( void ) _applicationDidResignActive: ( NSNotification* )_Notif
    {
    #if DEBUG
    NSLog( @">>> (Log) Application did resign active: \n{\n    %@\n    Observer:%@\n}", _Notif, self );
    #endif

    [ self closeAttachPanel ];
    }

- ( void ) _timerFireMethod: ( NSTimer* )_Timer
    {
    #if DEBUG
    NSLog( @">>> (Invocation) %s", __PRETTY_FUNCTION__ );
    #endif

    [ self _searchWikiPagesBasedThatHaveValue: _Timer.userInfo[ @"value" ] ];
    [ _Timer invalidate ];
    }

- ( void ) _searchWikiPagesBasedThatHaveValue: ( NSString* )_Value
    {
    [ self->_instantSearchWikiEngine searchAllPagesThatHaveValue: _Value
                                                    inNamespaces: nil
                                                            what: WikiEngineSearchWhatPageText
                                                           limit: 10
                                                         success:
        ^( NSArray* _MatchedPages )
            {
            if ( _MatchedPages )
                [ [ NSNotificationCenter defaultCenter ] postNotificationName: PureWikiDidSearchPagesNotif
                                                                       object: self
                                                                     userInfo: @{ kPages : _MatchedPages } ];
            } failure:
                ^( NSError* _Error )
                    {
                    NSLog( @"%@", _Error );
                    } stopAllOtherTasks: YES ];
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