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

- ( void ) awakeFromNib
    {
    self.smartSearchAttachViewController = [ [ PWSmartSearchAttachViewController alloc ] init ];

    NSMenuItem* fuckingItem = [ [ NSMenuItem alloc ] init ];
    [ fuckingItem setView: self.smartSearchAttachViewController.view ];

    [ self addItem: fuckingItem ];
    }

@end
