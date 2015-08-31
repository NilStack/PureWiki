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

#import "NSColor+TKSafariSearchbar.h"
#import "__TKTextLayer.h"

@implementation __TKTextLayer

@dynamic content;
@dynamic size;

#pragma mark Initializations
+ ( instancetype ) layerWithContent: ( NSString* )_Content
    {
    return [ [ self alloc ] initWithContent: _Content ];
    }

- ( instancetype ) initWithContent: ( NSString* )_Content
    {
    if ( self = [ super init ] )
        {
        self->_fontAttr = [ NSFont systemFontOfSize: 13.f ];
        self->_foregroundColorAttr = [ NSColor colorWithHTMLColor: @"B2B2B2" ];

        [ self setContent: _Content ];

        // This's very important to get text in receiver to be clear
        [ self setContentsScale: 2.f ];
        }

    return self;
    }

#pragma mark Dynamic Properties
- ( void ) setContent: ( NSString* )_Content
    {
    NSDictionary* attributes = @{ NSFontAttributeName : self->_fontAttr
                                , NSForegroundColorAttributeName : self->_foregroundColorAttr
                                };

    NSAttributedString* attredString = [ [ NSAttributedString alloc ] initWithString: _Content
                                                                          attributes: attributes ];

    [ self setString: attredString ];
    [ self setBounds: NSMakeRect( 0, 0, self.size.width, self.size.height ) ];
    }

- ( NSString* ) content
    {
    NSString* content = nil;
    id string = [ self string ];

    if ( [ string isKindOfClass: [ NSAttributedString class ] ] )
        content = [ ( NSAttributedString* )string string ];

    else if ( [ string isKindOfClass: [ NSString class ] ] )
        content = string;

    return content;
    }

- ( NSSize ) size
    {
    NSString* string = [ [ self string ] string ];
    NSDictionary* attributes = [ self.string attributesAtIndex: 0 effectiveRange: NULL ];

    return [ string sizeWithAttributes: attributes ];
    }

@end

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