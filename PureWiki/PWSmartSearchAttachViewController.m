//
//  PWSmartSearchAttachViewController.m
//  PureWiki
//
//  Created by Tong G. on 8/19/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "PWSmartSearchAttachViewController.h"

@interface PWSmartSearchAttachViewController ()

@end

@implementation PWSmartSearchAttachViewController

+ ( instancetype ) attachViewController
    {
    return [ [ [ self class ] alloc ] initWithSize: NSZeroSize ];
    }

- ( instancetype ) init
    {
    if ( self = [ super initWithNibName: @"PWSmartSearchAttachView" bundle: [ NSBundle mainBundle  ] ] )
        ;

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

@end
