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

#import "PWWikiPageBackForwardList.h"
#import "PWOpenedWikiPage.h"

#import "WikiPage.h"

// PWWikiPageBackForwardList class
@implementation PWWikiPageBackForwardList

- ( NSString* ) description
    {
    NSString* splitter = @"\n--------------------------------------------\n";
    NSMutableString* logString = [ NSMutableString stringWithFormat: @"%@Wiki Page Back-Forward List:\n", splitter ];

    NSUInteger index = 0U;
    for ( PWOpenedWikiPage* _OpenedWikiPage in self->__backingStore )
        {
        [ logString appendFormat: @" %@ %lu) %@\n"
                                , ( self.currentItem == _OpenedWikiPage ) ? @">>>" : @"   "
                                , index
                                , [ NSString stringWithFormat: @"(%p)🐠%@ => %@"
                                                             , _OpenedWikiPage
                                                             , _OpenedWikiPage.openedWikiPage.URL
                                                             , _OpenedWikiPage.simplifiedURLString
                                                             ]
                                ];
        index++;
        }

    [ logString appendString: splitter ];
    return [ logString copy ];
    }

#pragma mark Initializations
+ ( instancetype ) backForwardList
    {
    return [ [ self alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        self->__backingStore = [ NSMutableArray array ];
        self->__cursor = -1;
        }

    return self;
    }

#pragma mark Moving and Removing Items
// Inserts an opened Wiki page into the back-forward list, immediately after the current item.
- ( void ) addItem: ( PWOpenedWikiPage* )_OpendedWikiPage
    {
    if ( _OpendedWikiPage )
        {
        if ( self->__cursor < self->__backingStore.count - 1 )
            {
            NSRange deperactedRange = NSMakeRange( self->__cursor + 1, self->__backingStore.count - ( self->__cursor + 1 ) );
            NSIndexSet* deperactedIndexSet = [ NSIndexSet indexSetWithIndexesInRange: deperactedRange ];
            [ self->__backingStore removeObjectsAtIndexes: deperactedIndexSet ];
            }

        [ self->__backingStore addObject: _OpendedWikiPage ];
        self->__cursor = self->__backingStore.count - 1;
        }
    }

- ( void ) cleanUp
    {
    [ self->__backingStore removeAllObjects ];
    self->__cursor = -1;
    }

#pragma mark Moving Backward and Forward
// Moves backward one page in the back-forward list.
- ( void ) goBack
    {
    if ( self->__cursor > -1 )
        self->__cursor--;
    }

// Moves forward one page in the back-forward list.
- ( void ) goForward
    {
    if ( self->__cursor < ( self->__backingStore.count - 1 ) )
        self->__cursor++;
    }

#pragma mark Querying the Back-Forward List
// Returns the page that precedes the current page in the back-forward list.
- ( PWOpenedWikiPage* ) backItem
    {
    PWOpenedWikiPage* result = nil;

    if ( ( self->__cursor - 1 ) > -1 )
        result = self->__backingStore[ self->__cursor - 1 ];

    return result;
    }

// Returns the current page in the back-forward list.
- ( PWOpenedWikiPage* ) currentItem
    {
    PWOpenedWikiPage* result = nil;

    if ( self->__cursor > -1 )
        result = self->__backingStore[ self->__cursor ];

    return result;
    }

// Returns the page that follows the current page in the back-forward list.
- ( PWOpenedWikiPage* ) forwardItem
    {
    PWOpenedWikiPage* result = nil;

    if ( ( self->__cursor + 1 ) < self->__backingStore.count )
        result = self->__backingStore[ self->__cursor + 1 ];

    return result;
    }

// Returns the number of pages that precede the current page in the back-forward list.
- ( NSInteger ) backListCount
    {
    return ( self->__cursor > -1 ) ? ( self->__cursor /* + 1 - 1 */ ) : 0;
    }

// Returns the number of pages that follow the current page in the back-forward list.
- ( NSInteger ) forwardListCount
    {
    return self->__backingStore.count - ( self->__cursor + 1 );
    }

// Returns a Boolean value indicating whether the back-forward list contains the specified page.
- ( BOOL ) containsItem: ( PWOpenedWikiPage* )_OpenedPage
    {
    return [ self->__backingStore containsObject: _OpenedPage ];
    }

@end // PWWikiPageBackForwardList class

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