//
//  PWOpenedWikiPage.m
//  PureWiki
//
//  Created by Tong G. on 9/2/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWOpenedWikiPage.h"

#import "WikiPage.h"

// PWOpenedWikiPage class
@implementation PWOpenedWikiPage

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
