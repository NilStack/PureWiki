//
//  PWBrain.h
//  PureWiki
//
//  Created by Tong G. on 8/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiEngine.h"

@interface PWBrain : NSObject
    {
@protected
    WikiEngine __strong* _wikiEngine;
    }

@property ( strong, readonly ) WikiEngine* wikiEngine;

#pragma mark Singleton Initializer
+ ( instancetype ) wiseBrain;

#pragma mark Actions
- ( void ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                          inNamespaces: ( NSArray* )_Namespaces
                                  what: ( WikiEngineSearchWhat )_SearchWhat
                                 limit: ( NSUInteger )_Limit
                               success: ( void (^)( NSArray* _MatchedPages ) )_SuccessBlock
                               failure: ( void (^)( NSError* _Error ) )_FailureBlock;
@end
