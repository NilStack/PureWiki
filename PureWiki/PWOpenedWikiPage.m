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
    return [ NSString stringWithFormat: @"%@ : %@", self.contentViewUUID, self.currentOpenedWikiPage.URL ];
    }

#pragma mark Initializations
+ ( instancetype ) openedWikiPageWithContentViewUUID: ( NSString* )_UUID
                               currentOpenedWikiPage: ( WikiPage* )_WikiPage
    {
    return [ [ self alloc ] initWithContentViewUUID: _UUID currentOpenedWikiPage: _WikiPage ];
    }

- ( instancetype ) initWithContentViewUUID: ( NSString* )_UUID
                     currentOpenedWikiPage: ( WikiPage* )_WikiPage
    {
    if ( self = [ super init ] )
        {
        self.contentViewUUID = _UUID;
        self.currentOpenedWikiPage = _WikiPage;
        }

    return self;
    }

#pragma mark Comparing
- ( BOOL ) isEqualToOpendedWikiPage: ( PWOpenedWikiPage* )_Rhs
    {
    if ( self == _Rhs )
        return YES;

    return [ self.contentViewUUID isEqualToString: _Rhs.contentViewUUID ];
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