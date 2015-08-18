//
//  PWStackContainerView.m
//  PureWiki
//
//  Created by Tong G. on 8/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWStackContainerView.h"

@implementation PWStackContainerView

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    [ [ NSColor whiteColor ] set ];
    NSRectFill( _DirtyRect );
    }

@end
