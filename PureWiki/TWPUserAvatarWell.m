/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 _______    _             _                 _                 |██
|                (_______)  (_)           | |               | |                |██
|                    _ _ _ _ _ ____   ___ | |  _ _____  ____| |                |██
|                   | | | | | |  _ \ / _ \| |_/ ) ___ |/ ___)_|                |██
|                   | | | | | | |_| | |_| |  _ (| ____| |    _                 |██
|                   |_|\___/|_|  __/ \___/|_| \_)_____)_|   |_|                |██
|                             |_|                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "TWPUserAvatarWell.h"
#import "TWPUserAvatarCell.h"

#import "WikiEngine.h"
#import "WikiPage.h"
#import "WikiImage.h"

// Private Interfaces
@interface TWPUserAvatarWell ()
- ( BOOL ) _isEventUnderMyControl: ( NSEvent* )_Event;
@end // Private Interfaces

// TWPUserAvatarWell class
@implementation TWPUserAvatarWell

@dynamic wikiPage;

#pragma mark Initializations
- ( instancetype ) initWithCoder:(NSCoder *)coder
    {
    if ( self = [ super initWithCoder: coder ] )
        {
        self->_HTTPSessionManager = [ AFHTTPSessionManager manager ];
        [ self->_HTTPSessionManager setResponseSerializer: [ [ AFImageResponseSerializer alloc ] init ] ];
        self->_wikiEngine = [ WikiEngine commonsEngine ];
        }

    return self;
    }

- ( void ) awakeFromNib
    {
    // The self->_trackingArea will be created with `NSTrackingInVisibleRect` option,
    // in which case the Application Kit handles the re-computation of self->_trackingArea
    self->_trackingAreaOptions = NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp
                                    | NSTrackingInVisibleRect | NSTrackingAssumeInside | NSTrackingMouseMoved;
    self->_trackingArea =
        [ [ NSTrackingArea alloc ] initWithRect: self.bounds options: self->_trackingAreaOptions owner: self userInfo: nil ];

    [ self addTrackingArea: self->_trackingArea ];
    }

#pragma mark Accessors
- ( void ) setWikiPage: ( WikiPage* )_WikiPage
    {
    [ self.cell setHighlighted: NO ];

    if ( self->_wikiPage != _WikiPage )
        {
        [ self setImage: nil ];
        self->_wikiPage = _WikiPage;

        [ self->_wikiEngine fetchImage: self->_wikiPage.pageImageName
                               success:
        ^( WikiImage* _WikiImage )
            {
            NSURL* avatarURL = _WikiImage.URL;
            self->_dataTask = [ self->_HTTPSessionManager GET: avatarURL.absoluteString
                                                   parameters: nil
                                                      success:
              ^( NSURLSessionDataTask* _Task, id _ResponseObject )
                    {
                    NSImage* avatarImage = ( NSImage* )_ResponseObject;
                    [ self performSelectorOnMainThread: @selector( setImage: ) withObject: avatarImage waitUntilDone: NO ];
                    } failure:
                        ^( NSURLSessionDataTask* _Task, NSError* _Error )
                            {

                            } ];

            [ self->_dataTask resume ];
            } failure:
                ^( NSError* _Error )
                    {

                    } ];
        }
    }

- ( WikiPage* ) wikiPage
    {
    return self->_wikiPage;
    }

#pragma mark Events Handling
- ( void ) mouseDown: ( NSEvent* )_Event
    {
    [ super mouseDown: _Event ];

    if ( [ self _isEventUnderMyControl: _Event ] )
        {
        [ self.cell setHighlighted: NO ];
        [ NSApp sendAction: self.action to: self.target from: self ];
        }
    }

- ( void ) mouseEntered: ( NSEvent* )_Event
    {
    [ super mouseEntered: _Event ];

    if ( [ self _isEventUnderMyControl: _Event ] )
        [ self.cell setHighlighted: YES ];
    }

- ( void ) mouseExited: ( NSEvent* )_Event
    {
    [ super mouseExited: _Event ];

    if ( [ self.cell isHighlighted ] )
        [ self.cell setHighlighted: NO ];
    }

- ( void ) scrollWheel: ( NSEvent* )_Event
    {
    [ super scrollWheel: _Event ];
    [ self.cell setHighlighted: NO ];
    }

- ( void ) mouseMoved: ( nonnull NSEvent* )_Event
    {
    [ super mouseMoved: _Event ];
    [ self.cell setHighlighted: [ self _isEventUnderMyControl: _Event ] ];
    }

#pragma mark Custom Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    // TODO: Custom Drawing
    }

- ( Class ) cellClass
    {
    return [ TWPUserAvatarCell class ];
    }

#pragma mark Private Interfaces
- ( BOOL ) _isEventUnderMyControl: ( NSEvent* )_Event
    {
    NSPoint eventLocation = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];
    NSBezierPath* boundsPath = [ self.cell avatarOutlinePath ];
    return [ boundsPath containsPoint: eventLocation ];
    }

@end // TWPUserAvatarWell class

/*=============================================================================┐
|                                                                              |
|                                        `-://++/:-`    ..                     |
|                    //.                :+++++++++++///+-                      |
|                    .++/-`            /++++++++++++++/:::`                    |
|                    `+++++/-`        -++++++++++++++++:.                      |
|                     -+++++++//:-.`` -+++++++++++++++/                        |
|                      ``./+++++++++++++++++++++++++++/                        |
|                   `++/++++++++++++++++++++++++++++++-                        |
|                    -++++++++++++++++++++++++++++++++`                        |
|                     `:+++++++++++++++++++++++++++++-                         |
|                      `.:/+++++++++++++++++++++++++-                          |
|                         :++++++++++++++++++++++++-                           |
|                           `.:++++++++++++++++++/.                            |
|                              ..-:++++++++++++/-                              |
|                             `../+++++++++++/.                                |
|                       `.:/+++++++++++++/:-`                                  |
|                          `--://+//::-.`                                      |
|                                                                              |
└=============================================================================*/