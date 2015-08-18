//
//  PWBrain.m
//  PureWiki
//
//  Created by Tong G. on 8/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWBrain.h"

@implementation PWBrain

@dynamic wikiEngine;

#pragma mark Singleton Initializer
id static sWiseBrain = nil;
+ ( instancetype ) wiseBrain
    {
    return [ [ [ self class ] alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( !sWiseBrain )
        {
        if ( self = [ super init ] )
            {
            // TODO:
            self->_wikiEngine = [ WikiEngine engineWithISOLanguageCode: @"en" ];
            sWiseBrain = self;
            }
        }

    return sWiseBrain;
    }

#pragma mark Dynamic Properties
- ( WikiEngine* ) wikiEngine
    {
    return self->_wikiEngine;
    }

#pragma mark Actions
- ( void ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                          inNamespaces: ( NSArray* )_Namespaces
                                  what: ( WikiEngineSearchWhat )_SearchWhat
                                 limit: ( NSUInteger )_Limit
                               success: ( void (^)( NSArray* _MatchedPages ) )_SuccessBlock
                               failure: ( void (^)( NSError* _Error ) )_FailureBlock
    {
    [ self->_wikiEngine searchAllPagesThatHaveValue: _SearchValue
                                       inNamespaces: _Namespaces
                                               what: _SearchWhat
                                              limit: _Limit
                                            success: _SuccessBlock
                                            failure: _FailureBlock ];
    }

@end
