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

#import "PWBrain.h"

// PWBrain class
@implementation PWBrain

@dynamic instantSearchWikiEngine;

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
            self->_instantSearchWikiEngine = [ WikiEngine engineWithISOLanguageCode: @"en" ];
            sWiseBrain = self;
            }
        }

    return sWiseBrain;
    }

#pragma mark Dynamic Properties
- ( WikiEngine* ) wikiEngine
    {
    return self->_instantSearchWikiEngine;
    }

#pragma mark Controlling Task State
- ( void ) cancelInstantSearchWiki
    {
    [ self->_instantSearchWikiEngine cancelAll ];
    }

#pragma mark Actions
- ( void ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                          inNamespaces: ( NSArray* )_Namespaces
                                  what: ( WikiEngineSearchWhat )_SearchWhat
                                 limit: ( NSUInteger )_Limit
                               success: ( void (^)( NSArray* _MatchedPages ) )_SuccessBlock
                               failure: ( void (^)( NSError* _Error ) )_FailureBlock
    {
    [ self->_instantSearchWikiEngine searchAllPagesThatHaveValue: _SearchValue
                                                    inNamespaces: _Namespaces
                                                            what: _SearchWhat
                                                           limit: _Limit
                                                         success: _SuccessBlock
                                                         failure: NO ];
    }

- ( void ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                          inNamespaces: ( NSArray* )_Namespaces
                                  what: ( WikiEngineSearchWhat )_SearchWhat
                                 limit: ( NSUInteger )_Limit
                               success: ( void (^)( NSArray* _MatchedPages ) )_SuccessBlock
                               failure: ( void (^)( NSError* _Error ) )_FailureBlock
                     stopAllOtherTasks: ( BOOL )_WillStop
    {
    [ self->_instantSearchWikiEngine searchAllPagesThatHaveValue: _SearchValue
                                                    inNamespaces: _Namespaces
                                                            what: _SearchWhat
                                                           limit: _Limit
                                                         success: _SuccessBlock
                                                         failure: _FailureBlock
                                               stopAllOtherTasks: _WillStop ];
    }

@end // PWBrain class

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