//
//  NSObject+PWSmartSearchBar.m
//  PureWiki
//
//  Created by Tong G. on 8/21/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import <objc/message.h>

#import "NSObject+PWSmartSearchBar.h"

@implementation NSObject ( PWSmartSearchBar )

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

@end
