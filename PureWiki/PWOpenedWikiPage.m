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

// PWOpenedWikiPage class
@implementation PWOpenedWikiPage

@synthesize hostContentViewUUID;
@synthesize openedWikiPage;
@dynamic URL;
@dynamic simplifiedURLString;

@synthesize xOffset;
@synthesize yOffset;

- ( NSString* ) description
    {
    return [ NSString stringWithFormat: @"(%p)%@ : %@", self, self.hostContentViewUUID, self.openedWikiPage.URL ];
    }

#pragma mark Initializations
+ ( instancetype ) openedWikiPageWithHostContentViewUUID: ( NSString* )_UUID
                                          openedWikiPage: ( WikiPage* )_WikiPage
                                                     URL: ( NSURL* )_URL
    {
    return [ [ self alloc ] initWithHostContentViewUUID: _UUID openedWikiPage: _WikiPage URL: _URL ];
    }

- ( instancetype ) initWithHostContentViewUUID: ( NSString* )_UUID
                                openedWikiPage: ( WikiPage* )_WikiPage
                                           URL: ( NSURL* )_URL
    {
    if ( self = [ super initWithURLString: _URL.absoluteString
                                    title: _WikiPage.title
                  lastVisitedTimeInterval: 0.f ] )
        {
        self.hostContentViewUUID = _UUID;
        self.openedWikiPage = _WikiPage;

        self.xOffset = 0.f;
        self.yOffset = 0.f;
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

#pragma mark Dynamic Properties
- ( NSURL* ) URL
    {
    return [ NSURL URLWithString: self.URLString ];
    }

- ( NSString* ) simplifiedURLString
    {
    return [ NSString stringWithFormat: @"%@://…/%@", self.URL.scheme, self.URL.lastPathComponent ];
    }

#pragma mark Conforms to <NSCopying>
- ( id ) copyWithZone: ( nullable NSZone* )_Zone
    {
    PWOpenedWikiPage* copy = [ super copyWithZone: _Zone ];

    [ copy setHostContentViewUUID: [ self.hostContentViewUUID copy ] ];
    [ copy setOpenedWikiPage: [ self.openedWikiPage copy ] ];

    return copy;
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