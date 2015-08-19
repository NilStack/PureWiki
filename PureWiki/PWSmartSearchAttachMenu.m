//
//  PWSmartSearchAttachMenu.m
//  PureWiki
//
//  Created by Tong G. on 8/19/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWSmartSearchAttachMenu.h"
#import "PWSmartSearchAttachViewController.h"

@implementation PWSmartSearchAttachMenu

@dynamic size;

- ( void ) awakeFromNib
    {
    self.smartSearchAttachViewController = [ [ PWSmartSearchAttachViewController alloc ] init ];

    NSMenuItem* fuckingItem = [ [ NSMenuItem alloc ] init ];
    [ fuckingItem setView: self.smartSearchAttachViewController.view ];

    [ self addItem: fuckingItem ];
    }

- ( void ) setSize: ( NSSize )_Size
    {
    [ self.smartSearchAttachViewController.view setFrameSize: _Size ];
    }

- ( NSSize ) size
    {
    return self.smartSearchAttachViewController.view.frame.size;
    }

@end
