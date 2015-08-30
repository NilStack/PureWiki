/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 ______                   _  _  _ _ _     _ _                 |██
|                (_____ \                 (_)(_)(_|_) |   (_) |                |██
|                 _____) )   _  ____ _____ _  _  _ _| |  _ _| |                |██
|                |  ____/ | | |/ ___) ___ | || || | | |_/ ) |_|                |██
|                | |    | |_| | |   | ____| || || | |  _ (| |_                 |██
|                |_|    |____/|_|   |_____)\_____/|_|_| \_)_|_|                |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "NSColor+TKSafariSearchbar.h"
#import "__TKSearchbarBackingLayer.h"

@implementation __TKSearchbarBackingLayer

#pragma mark Initializations
+ ( instancetype ) layerWithHostView: ( NSView* )_HostView
    {
    return [ [ self alloc ] initWithHostView: _HostView ];
    }

- ( instancetype ) initWithHostView: ( NSView* )_HostView
    {
    if ( self = [ super init ] )
        {
        self->_hostView = _HostView;

        [ self setBounds: _HostView.bounds ];
        [ self setPosition: CGPointMake( NSMinX( self.frame ), NSMinY( self.frame ) ) ];
        [ self setContentsScale: 2.f ];
        }

    return self;
    }

- ( void ) drawInContext: ( nonnull CGContextRef )_cgCtx
    {
    CGMutablePathRef cgPath = CGPathCreateMutable();

    CGPathAddRoundedRect( cgPath, NULL, NSInsetRect( self.bounds, 1.f, 1.f ), 4.f, 4.f );

    CGContextAddPath( _cgCtx, cgPath );

    CGContextSetFillColorWithColor( _cgCtx, [ NSColor whiteColor ].CGColor );
    CGContextSetLineWidth( _cgCtx, 3.f );
    CGContextSetShadowWithColor( _cgCtx, CGSizeMake( 0.f, .3f ), .7f, [ [ NSColor blackColor ] colorWithAlphaComponent: .2f ].CGColor );
    CGContextFillPath( _cgCtx );

    CFRelease( cgPath );
    }

@end

/*===============================================================================┐
|                                                                                | 
|                      ++++++     =++++~     +++=     =+++                       | 
|                        +++,       +++      =+        ++                        | 
|                        =+++       ~+++     +        =+                         | 
|                         +++=       =++=   +=        +                          | 
|                          +++        +++= +=        +=                          | 
|                          =+++        ++++=        =+                           | 
|                           +++=       =+++         +                            | 
|                            +++~       +++=       +=                            | 
|                            ,+++      ~++++=     ==                             | 
|                             ++++     +  +++     +                              | 
|                              +++=   +   ~+++   +,                              | 
|                               +++  +:    =+++ ==                               | 
|                               =++++=      +++++                                | 
|                                +++=        +++                                 | 
|                                 ++          +=                                 | 
|                                                                                | 
└===============================================================================*/