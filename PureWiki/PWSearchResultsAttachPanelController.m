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

@dynamic searchResultsAttachPanel;

#pragma mark Initializations
+ ( instancetype ) controllerWithRelativeView: ( NSView* )_RelativeView
    {
    return [ [ self alloc ] initWithRelativeView: _RelativeView ];
    }

- ( instancetype ) initWithRelativeView: ( NSView* )_RelativeView
    {
    if ( self = [ super initWithWindowNibName: @"PWSearchResultsAttachPanel" owner: self ] )
        {
        self.relativeView = _RelativeView;

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
- ( void ) popUpAttachPanel
    {
    if ( self.relativeView )
        {
        NSRect windowFrameOfRelativeView = [ self.relativeView convertRect: self.relativeView.frame toView: nil ];
        NSRect screenFrameOfRelativeView = [ self.relativeView.window convertRectToScreen: windowFrameOfRelativeView ];

        NSPoint attachPanelOrigin = screenFrameOfRelativeView.origin;
        attachPanelOrigin.x -= 3.5f;
        attachPanelOrigin.y -= NSHeight( self.searchResultsAttachPanel.frame ) - 4.f;

        [ self popUpAttachPanelOnWindow: self.relativeView.window at: attachPanelOrigin ];
        }

    // TODO: Error Handling
    }

- ( void ) popUpAttachPanelOnWindow: ( NSWindow* )_ParentWindow
                                  at: ( NSPoint )_PointInScreen
    {
    if ( _ParentWindow )
        {
        NSParameterAssert( _ParentWindow != self.searchResultsAttachPanel );
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
    [ self stopSearchingAndClearResults ];
    }

#pragma mark Handling Search Results
@dynamic isInUse;

- ( BOOL ) isInUse
    {
    return self->_fetchedWikiPages.count > 0;
    }

- ( void ) searchValue: ( NSString* )SearchValue
    {
    // TODO:
    if ( SearchValue.length > 0 )
        {
        [ self->_timer invalidate ];
        self->_timer = [ NSTimer timerWithTimeInterval: ( NSTimeInterval ).6f
                                                target: self
                                              selector: @selector( _timerFireMethod: )
                                              userInfo: @{ @"value" : SearchValue }
                                               repeats: NO ];

        [ [ NSRunLoop currentRunLoop ] addTimer: self->_timer forMode: NSDefaultRunLoopMode ];
        }

    // if user emptied the search field
    else if ( SearchValue.length == 0 )
        {
        [ self stopSearching ];
        [ [ NSNotificationCenter defaultCenter ] postNotificationName: PureWikiDidEmptySearchNotif
                                                               object: self
                                                             userInfo: nil ];
        }
    }

// Stop searching but remains the search results
- ( void ) stopSearching
    {
    if ( self->_timer )
        {
        [ self->_timer invalidate ];
        self->_timer = nil;
        }

    [ self->_instantSearchWikiEngine cancelAll ];
    }

// Stop searching and clears all the search results
- ( void ) stopSearchingAndClearResults
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

#pragma mark Dynamic Properties
- ( PWSearchResultsAttachPanel* ) searchResultsAttachPanel
    {
    return ( PWSearchResultsAttachPanel* )( self.window );
    }

#pragma mark Private Interfaces
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
                {
                [ self->_fetchedWikiPages removeAllObjects ];
                [ self->_fetchedWikiPages addObjectsFromArray: _MatchedPages ];
                [ self.searchResultsTableView reloadData ];

                [ self popUpAttachPanel ];
                }
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