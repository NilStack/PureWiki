//
//  PWSmartSearchPreviewContentView.m
//  PureWiki
//
//  Created by Tong G. on 8/19/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWSmartSearchPreviewContentView.h"

@implementation PWSmartSearchPreviewContentView

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    NSBezierPath* roundedBoundsPath = [ NSBezierPath bezierPathWithRoundedRect: self.frame xRadius: 10.f yRadius: 10.f ];
    [ roundedBoundsPath addClip ];

    [ super drawRect: _DirtyRect ];
    }

@end
