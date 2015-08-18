//
//  PWMainContentView.m
//  PureWiki
//
//  Created by Tong G. on 8/18/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWMainContentView.h"

@implementation PWMainContentView

- ( void ) awakeFromNib
    {
    self.material= NSVisualEffectMaterialLight;
    self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    self.state = NSVisualEffectStateActive;
    }

@end
