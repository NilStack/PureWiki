//
//  PWSplitView.m
//  PureWiki
//
//  Created by Tong G. on 8/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWSplitView.h"

@implementation PWSplitView

- ( void ) awakeFromNib
    {
    [ self setHoldingPriority: NSLayoutPriorityFittingSizeCompression forSubviewAtIndex: 1 ];
    }

@end
