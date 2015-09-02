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

#import "PWOpenedWikiPage.h"

#import "WikiPage.h"

// PWOpenedWikiPage class
@implementation PWOpenedWikiPage

- ( NSString* ) description
    {
    return [ NSString stringWithFormat: @"%@ : %@", self.hostContentViewUUID, self.openedWikiPage.URL ];
    }

#pragma mark Initializations
+ ( instancetype ) openedWikiPageWithHostContentViewUUID: ( NSString* )_UUID
                                          openedWikiPage: ( WikiPage* )_WikiPage
    {
    return [ [ self alloc ] initWithHostContentViewUUID: _UUID openedWikiPage: _WikiPage ];
    }

- ( instancetype ) initWithHostContentViewUUID: ( NSString* )_UUID
                                openedWikiPage: ( WikiPage* )_WikiPage
    {
    if ( self = [ super initWithURLString: _WikiPage.URL.absoluteString
                                    title: _WikiPage.title
                  lastVisitedTimeInterval: 0.f ] )
        {
        self.hostContentViewUUID = _UUID;
        self.openedWikiPage = _WikiPage;
        }

    return self;
    }

#pragma mark Comparing
- ( BOOL ) isEqualToOpendedWikiPage: ( PWOpenedWikiPage* )_Rhs
    {
    if ( self == _Rhs )
        return YES;

    return [ self.hostContentViewUUID isEqualToString: _Rhs.hostContentViewUUID ];
    }

- ( BOOL ) isEqual: ( id )_Rhs
    {
    if ( self == _Rhs )
        return YES;

    if ( [ _Rhs isKindOfClass: [ self class ] ] )
        return [ self isEqualToOpendedWikiPage: ( PWOpenedWikiPage* )_Rhs ];

    return [ super isEqual: _Rhs ];
    }

@end // PWOpenedWikiPage class

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