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

#import "PWWikiContentViewController.h"
#import "PWWikiContentView.h"

#import "WikiPage.h"

// Private Interfaces
@interface PWWikiContentViewController ()
@end // Private Interfaces

// PWWikiContentViewController class
@implementation PWWikiContentViewController

@dynamic wikiContentView;
@dynamic UUID;

#pragma mark Initializations
+ ( instancetype ) controllerWithWikiPage: ( WikiPage* )_WikiPage
                                    owner: ( id <PWWikiContentViewOwner> )_Owner
    {
    return [ [ [ self class ] alloc ] initWithWikiPage: _WikiPage owner: _Owner ];
    }

- ( instancetype ) initWithWikiPage: ( WikiPage* )_WikiPage
                              owner: ( id <PWWikiContentViewOwner> )_Owner
    {
    if ( self = [ super initWithNibName: @"PWWikiContentView" bundle: [ NSBundle mainBundle ] ] )
        {
        [ self.wikiContentView setWikiPage: _WikiPage ];
        [ self.wikiContentView setOwner: _Owner ];
        }

    return self;
    }

#pragma mark Ivar Properties
- ( PWWikiContentView* ) wikiContentView
    {
    return ( PWWikiContentView* )( self.view );
    }

- ( NSString* ) UUID
    {
    return self.wikiContentView.UUID;
    }

@end // PWWikiContentViewController class

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