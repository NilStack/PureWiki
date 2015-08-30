//
//  __TKTextLayer.h
//  PureWiki
//
//  Created by Tong G. on 8/30/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import QuartzCore;
@import Cocoa;

@interface __TKTextLayer : CATextLayer
    {
@protected
    NSFont __strong* _fontAttr;
    NSColor __strong* _foregroundColorAttr;
    }

#pragma mark Initializations
+ ( instancetype ) layerWithContent: ( NSString* )_Content;
- ( instancetype ) initWithContent: ( NSString* )_Content;

@end
