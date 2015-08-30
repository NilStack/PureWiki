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

#import "__TKPlaceholderLayer.h"

// __TKPlaceholderLayer class
@implementation __TKPlaceholderLayer

@dynamic placeholderContent;

#pragma mark Initializations
+ ( instancetype ) layerWithContent: ( NSString* )_Content
    {
    return [ [ self alloc ] initWithContent: _Content ];
    }

- ( instancetype ) initWithContent: ( NSString* )_Content
    {
    if ( self = [ super init ] )
        {
        self->_fontAttr = [ NSFont systemFontOfSize: 15.f ];
        self->_foregroundColorAttr = [ NSColor redColor ];

        self.placeholderContent = _Content ?: @"";

        [ self setAnchorPoint: NSMakePoint( 0, 0 ) ];

        // This's very important to get text in receiver to be clear
        [ self setContentsScale: 2.f ];
        }

    return self;
    }

#pragma mark Dynamic Properties
- ( void ) setPlaceholderContent: ( NSString* )_PlaceholderContent
    {
    if ( self->_placeholderContent != _PlaceholderContent )
        {
        self->_placeholderContent = _PlaceholderContent;

        NSDictionary* attributes = @{ NSFontAttributeName : self->_fontAttr
                                    , NSForegroundColorAttributeName : self->_foregroundColorAttr
                                    };

        NSAttributedString* attredString = [ [ NSAttributedString alloc ] initWithString: _PlaceholderContent
                                                                              attributes: attributes ];

        [ self setString: attredString ];

        NSSize sizeWithAttributes = [ attredString.string sizeWithAttributes: attributes ];
        [ self setBounds: NSMakeRect( 0, 0, sizeWithAttributes.width, sizeWithAttributes.height ) ];
        }
    }

- ( NSString* ) placeholderContent
    {
    return self->_placeholderContent;
    }

@end // __TKPlaceholderLayer class

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