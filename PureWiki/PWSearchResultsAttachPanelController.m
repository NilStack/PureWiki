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

#import "SugarWiki.h"

NSString* const kResultsColumnID = @"results-column";

// Private Interfaces
@interface PWSearchResultsAttachPanelController ()

- ( void ) _didEmptySearchContent: ( NSNotification* )_Notif;
- ( void ) _applicationDidResignActive: ( NSNotification* )_Notif;
- ( void ) _applicationDidBecomeActive: ( NSNotification* )_Notif;

// Timer
- ( void ) _timerFireMethod: ( NSTimer* )_Timer;

// Searching
- ( void ) _searchWikiPagesBasedThatHaveValue: ( NSString* )_Value;

// Relative Window Notifications
- ( void ) _relativeWindowStartLiveResize: ( NSNotification* )_Notif;
- ( void ) _relativeWindowDidEndResize: ( NSNotification* )_Notif;

@end // Private Interfaces

// PWSearchResultsAttachPanelController class
@implementation PWSearchResultsAttachPanelController

@dynamic searchResultsAttachPanel;

@dynamic relativeView;

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

        self->_fetchedResults = [ NSMutableArray array ];
        self->_instantSearchWikiEngine = [ WikiEngine engineWithISOLanguageCode: @"en" ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( _didEmptySearchContent: )
                                                        name: PureWikiDidEmptySearchNotif
                                                      object: nil ];
        }

    return self;
    }

- ( void ) dealloc
    {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self name: PureWikiDidEmptySearchNotif object: nil ];
    }

- ( void ) windowDidLoad
    {
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _applicationDidResignActive: )
                                                    name: NSApplicationDidResignActiveNotification
                                                  object: nil ];

    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _applicationDidBecomeActive: )
                                                    name: NSApplicationDidBecomeActiveNotification
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
    [ self.searchResultsAttachPanel.parentWindow removeChildWindow: self.searchResultsAttachPanel ];
    [ self.searchResultsAttachPanel orderOut: self ];
    }

- ( void ) closeAttachPanelAndClearResults
    {
    [ self closeAttachPanel ];
    [ self stopSearchingAndClearResults ];
    }

#pragma mark Handling Search Results
@dynamic hasCompletedInstantSearch;
@dynamic isInUse;

- ( BOOL ) hasCompletedInstantSearch
    {
    return self->_instantSearchWikiEngine.hasCompletedAllQueryTasks;
    }

- ( BOOL ) isInUse
    {
    return !self.hasCompletedInstantSearch || self->_fetchedResults.count > 0;
    }

- ( void ) searchValue: ( NSString* )SearchValue
    {
    if ( SearchValue.length > 0 )
        {
        [ self stopSearchingAndClearResults ];

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
    [ self->_fetchedResults removeAllObjects ];
    [ self.searchResultsTableView reloadData ];

    self->__continuation = nil;
    self->__searchingValue = nil;
    self->__isLoadingMoreResults = NO;
    }

#pragma mark Conforms to <NSTableViewDataSource>
- ( NSInteger ) numberOfRowsInTableView: ( nonnull NSTableView* )_TableView
    {
    return self->_fetchedResults.count;
    }

- ( id )            tableView: ( nonnull NSTableView* )_TableView
    objectValueForTableColumn: ( nullable NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    id result = nil;

    if ( [ _TableColumn.identifier isEqualToString: kResultsColumnID ] )
        result = self->_fetchedResults[ _Row ];

    return result;
    }

#pragma mark Conforms to <NSTableViewDelegate>
- ( NSView* ) tableView: ( nonnull NSTableView* )_TableView
     viewForTableColumn: ( nullable NSTableColumn* )_TableColumn
                    row: ( NSInteger )_Row
    {
    PWSearchResultsTableCellView* tableCellView = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];
    WikiSearchResult* searchResult = ( WikiSearchResult* )( self->_fetchedResults[ _Row ] );
    [ tableCellView setWikiSearchResult: searchResult ];

    return tableCellView;
    }

- ( BOOL ) tableView: ( nonnull NSTableView* )_TableView
     shouldSelectRow: ( NSInteger )_Row
    {
    return NO;
    }

#pragma mark Conforms to <PWSearchResultsScrollViewDelegate>
- ( void ) searchResultsScrollView: ( PWSearchResultsScrollView* )_SearchResultsScrollView
            shouldFetchMoreResults: ( NSClipView* )_ClipView
    {
    [ self _searchWikiPagesBasedThatHaveValue: self->__searchingValue ];
    }

#pragma mark Dynamic Properties
- ( PWSearchResultsAttachPanel* ) searchResultsAttachPanel
    {
    return ( PWSearchResultsAttachPanel* )( self.window );
    }

- ( void ) setRelativeView: ( NSView* __nullable )_RelativeView
    {
    NSWindow* relativeWindow = self->_relativeView.window;
    if ( self->_relativeView )
        {
        [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                           name: NSWindowWillStartLiveResizeNotification
                                                         object: relativeWindow ];

        [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                           name: NSWindowDidEndLiveResizeNotification
                                                         object: relativeWindow ];
        }

    self->_relativeView = _RelativeView;
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _relativeWindowStartLiveResize: )
                                                    name: NSWindowWillStartLiveResizeNotification
                                                  object: relativeWindow ];

    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _relativeWindowDidEndResize: )
                                                    name: NSWindowDidEndLiveResizeNotification
                                                  object: relativeWindow ];
    }

- ( NSView* ) relativeView
    {
    return self->_relativeView;
    }

#pragma mark Private Interfaces
- ( void ) _didEmptySearchContent: ( NSNotification* )_Notif
    {
    [ self closeAttachPanelAndClearResults ];
    }

- ( void ) _applicationDidResignActive: ( NSNotification* )_Notif
    {
    #if DEBUG
    NSLog( @">>> (Log) Application did resign active: \n{\n    %@\n    Observer:%@\n}", _Notif, self );
    #endif

    [ self closeAttachPanel ];
    }

- ( void ) _applicationDidBecomeActive: ( NSNotification* )_Notif
    {
    if ( self.isInUse )
        [ self popUpAttachPanel ];
    }

- ( void ) _timerFireMethod: ( NSTimer* )_Timer
    {
    #if DEBUG
    NSLog( @">>> (Invocation) %s", __PRETTY_FUNCTION__ );
    #endif

    self->__searchingValue = _Timer.userInfo[ @"value" ];
    [ self popUpAttachPanel ];
    [ self _searchWikiPagesBasedThatHaveValue: self->__searchingValue ];
    [ _Timer invalidate ];
    }

- ( void ) _searchWikiPagesBasedThatHaveValue: ( NSString* )_Value
    {
    if ( !self->__isLoadingMoreResults )
        {
        self->__isLoadingMoreResults = YES;
        [ self->_instantSearchWikiEngine searchAllPagesThatHaveValue: _Value
                                                        inNamespaces: nil
                                                            approach: WikiEngineSearchApproachPageText
                                                               limit: 10
                                                       usesGenerator: NO
                                                        continuation: self->__continuation
                                                             success:
            ^( __SugarArray_of( WikiSearchResult* ) _SearchResults
             , WikiContinuation* _Continuation
             , BOOL _IsBatchComplete )
                {
                if ( _SearchResults )
                    {
                    self->__continuation = _Continuation;

                    [ self->_fetchedResults addObjectsFromArray: _SearchResults ];
                    [ self.searchResultsTableView reloadData ];
                    }

                self->__isLoadingMoreResults = NO;
                } failure:
                    ^( NSError* _Error )
                        {
                        NSLog( @"%@", _Error );
                        self->__isLoadingMoreResults = NO;
                        } stopAllOtherTasks: YES ];
        }
    }

- ( void ) _relativeWindowStartLiveResize: ( NSNotification* )_Notif
    {
    #if DEBUG
    NSLog( @">>> (Log) Relative window of attach panel starts live resize: \n{\n%@\n}", _Notif );
    #endif

    [ self closeAttachPanel ];
    }

- ( void ) _relativeWindowDidEndResize: ( NSNotification* )_Notif
    {
    #if DEBUG
    NSLog( @">>> (Log) Relative window of attach panel ends live resize: \n{\n%@\n}", _Notif );
    #endif

    if ( self.isInUse )
        [ self popUpAttachPanel ];
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