//
//  __TKTextLayer.m
//  PureWiki
//
//  Created by Tong G. on 8/30/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "NSColor+TKSafariSearchbar.h"
#import "__TKTextLayer.h"

@implementation __TKTextLayer

#pragma mark Initializations
+ ( instancetype ) layerWithContent: ( NSString* )_Content
    {
    return [ [ self alloc ] initWithContent: _Content ];
    }

- ( instancetype ) initWithContent: ( NSString* )_Content
    {
    if ( self = [ super init ] )
        {
        self->_fontAttr = [ NSFont systemFontOfSize: 12.f ];
        self->_foregroundColorAttr = [ NSColor colorWithHTMLColor: @"B2B2B2" ];
        }

    return self;
    }

@end
