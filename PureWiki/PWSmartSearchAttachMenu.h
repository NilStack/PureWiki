//
//  PWSmartSearchAttachMenu.h
//  PureWiki
//
//  Created by Tong G. on 8/19/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PWSmartSearchAttachViewController;

@interface PWSmartSearchAttachMenu : NSMenu

@property ( assign, readwrite ) NSSize size;
@property ( strong ) PWSmartSearchAttachViewController* smartSearchAttachViewController;

@end
