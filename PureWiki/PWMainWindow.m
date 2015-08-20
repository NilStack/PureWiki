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

#import "PWMainWindow.h"
#import <objc/message.h>

@implementation PWMainWindow

- ( id ) performSelector: ( SEL )_Selector
                 asClass: ( Class )_Class
    {
    struct objc_super newSuper =
        { .receiver = self
        , .super_class = class_isMetaClass( object_getClass( self ) )   // check if we are an instance or Class
                            ? object_getClass( _Class )                 // if we are a Class, we need to send our metaclass (our Class's Class)
                            : _Class                                    // if we are an instance, we need to send our Class (which we already have)
        };

    id ( *objc_superAllocTyped )( struct objc_super*, SEL ) = ( void* )&objc_msgSendSuper;  // cast our pointer so the compiler can sort out the ABI
    return ( *objc_superAllocTyped )( &newSuper, _Selector );
    }

- ( void ) awakeFromNib
    {
    self.titleVisibility = NSWindowTitleHidden;

    NSImage* image = [ self performSelector: @selector( _cornerMask ) asClass: self.superclass ];
    NSLog( @"%@", image );

    image = [ self performSelector: @selector( _cornerMask ) asClass: self.superclass ];
    NSLog( @"%@", image );

    NSImage* image1 = [ self performSelector: @selector( _cornerMask ) asClass: self.class ];
    NSLog( @"%@", image1 );
    }

- ( NSImage* ) _cornerMask
    {
    NSImage* image1 = [ self performSelector: @selector( _cornerMask ) asClass: self.superclass ];
    NSLog( @"🐒%@", image1 );

    return nil;
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