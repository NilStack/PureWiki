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

#import "PWPWikiPageImageWell.h"
#import "PWWikiPageImageCell.h"
#import "PWArtworkConstants.h"

#import "AFNetworking.h"
#import "SugarWiki.h"

// Private Interfaces
@interface PWPWikiPageImageWell ()
- ( BOOL ) _isEventUnderMyControl: ( NSEvent* )_Event;
@end // Private Interfaces

// PWPWikiPageImageWell class
@implementation PWPWikiPageImageWell

@dynamic wikiPage;

#pragma mark Initializations
- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        self->_HTTPSessionManager = [ AFHTTPSessionManager manager ];
        [ self->_HTTPSessionManager setResponseSerializer: [ [ AFCompoundResponseSerializer alloc ] init ] ];
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
- ( NSImage* ) __fuckingImage
    {
    return self->__isHostRowViewSelected ? [ NSImage imageNamed: PWArtworkWikiPageImageHighlighted ] : [ NSImage imageNamed: PWArtworkWikiPageImageNormal ];
    }

- ( void ) setWikiPage: ( WikiPage* )_WikiPage
    {
    [ self.cell setHighlighted: NO ];

//    NSImage* [ self __fuckingImage ] = [ self __fuckingImage ];

    if ( self->_wikiPage != _WikiPage )
        {
        self->_wikiPage = _WikiPage;

        void (^__handleFetchedPageImageData)( NSData*, NSURLResponse*, NSError* ) =
            ^( NSData* _ImageData, NSURLResponse* _Response, NSError* _Error )
                {
                if ( [ _Response.MIMEType isEqualToString: @"image/svg+xml" ] )
                    // TODO: Looking forward to integrate with the SVG converter tools like SVGKit
                    [ self performSelectorOnMainThread: @selector( setImage: ) withObject: [ self __fuckingImage ] waitUntilDone: NO ];
                else
                    {
                    NSImage* wikiPageImage = [ [ NSImage alloc ] initWithData: _ImageData ];
                    [ self performSelectorOnMainThread: @selector( setImage: ) withObject: wikiPageImage waitUntilDone: NO ];
                    }
                };

        if ( self->_wikiPage.pageImageName )
            {
            [ self->_wikiEngine fetchImage: self->_wikiPage.pageImageName
                                   success:
            ^( WikiImage* _WikiImage )
                {
                if ( _WikiImage )
                    {
                    NSURL* imageURL = _WikiImage.URL;

                    NSURLRequest* imageRequest = [ NSURLRequest requestWithURL: imageURL ];
                    NSCachedURLResponse* cachedRequest = [ [ NSURLCache sharedURLCache ] cachedResponseForRequest: imageRequest ];

                    if ( cachedRequest )
                        __handleFetchedPageImageData( cachedRequest.data, cachedRequest.response, nil );
                    else
                        {

                        self->_dataTask = [ self->_HTTPSessionManager GET: imageURL.absoluteString
                                                               parameters: nil
                                                                  success:
                          ^( NSURLSessionDataTask* _Task, id _ResponseObject )
                                {
                                __handleFetchedPageImageData( ( NSData* )_ResponseObject, _Task.response, nil );

                                NSCachedURLResponse* cache =
                                    [ [ NSCachedURLResponse alloc ] initWithResponse: _Task.response
                                                                                data: ( NSData* )_ResponseObject
                                                                            userInfo: nil
                                                                       storagePolicy: NSURLCacheStorageAllowed ];

                            [ [ NSURLCache sharedURLCache ] storeCachedResponse: cache forRequest: imageRequest ];
                                } failure:
                                    ^( NSURLSessionDataTask* _Task, NSError* _Error )
                                        {

                                        } ];

                        [ self->_dataTask resume ];
                        }
                    }
                } failure:
                    ^( NSError* _Error )
                        {
                        [ self performSelectorOnMainThread: @selector( setImage: ) withObject: [ self __fuckingImage ] waitUntilDone: NO ];
                        }  stopAllOtherTasks: YES ];
                }
        else
            [ self setImage: [ self __fuckingImage ] ];
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
    return [ PWWikiPageImageCell class ];
    }

#pragma mark Conforms to <PWSubviewOfSidebarTableRowView>
- ( void ) setHostRowViewSelected: ( BOOL )_YesOrNo
    {
    self->__isHostRowViewSelected = _YesOrNo;
    }

- ( BOOL ) isHostRowViewSelected
    {
    return self->__isHostRowViewSelected;
    }

#pragma mark Private Interfaces
- ( BOOL ) _isEventUnderMyControl: ( NSEvent* )_Event
    {
    NSPoint eventLocation = [ self convertPoint: [ _Event locationInWindow ] fromView: nil ];
    NSBezierPath* boundsPath = [ self.cell imageOutlinePath ];
    return [ boundsPath containsPoint: eventLocation ];
    }

@end // PWPWikiPageImageWell class

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