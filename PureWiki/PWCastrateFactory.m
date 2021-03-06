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

#import "PWCastrateFactory.h"
#import "PWUtilities.h"
#import "PWWikiPageArchive.h"

#import "NSURL+PureWiki.h"

// Private Interfaces
@interface PWCastrateFactory ()

@property ( strong, readonly ) NSString* _archiveBasePath;
@property ( strong, readonly ) NSURL* _archiveBaseURL;

@property ( strong, readonly ) NSString* _archiveBasePathWithoutCreation;
@property ( strong, readonly ) NSURL* _archiveBaseURLWithoutCreation;

- ( void ) _traverseNamedNodeMap: ( DOMNode* )_DOMNode;
- ( void ) _traverseDOMNodes: ( DOMNode* )_DOMNode;

@end // Private Interfaces

// PWCastrateFactory class
@implementation PWCastrateFactory

#pragma mark Initializations
id sDefaultFactory = nil;
+ ( instancetype ) defaultFactory
    {
    if ( !sDefaultFactory )
        sDefaultFactory = [ [ self alloc ] init ];

    return sDefaultFactory;
    }

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        self->_cssLabURL = [ [ NSBundle mainBundle ] URLForResource: @"purewikied-css" withExtension: @"css" ];
        self->_toBeCastrated = [ NSMutableArray array ];

        self->_fileManager = [ [ NSFileManager alloc ] init ];
        [ self->_fileManager setDelegate: self ];
        }

    return self;
    }

- ( PWWikiPageArchive* ) castrateFrameInMemory: ( WebFrame* )_Frame
    {
    DOMHTMLDocument* document = ( DOMHTMLDocument* )( _Frame.DOMDocument );

    [ self _traverseDOMNodes: document ];

    for ( DOMHTMLElement* _HTMLElem in self->_toBeCastrated )
        if ( _HTMLElem )
            [ _HTMLElem.parentElement removeChild: _HTMLElem ];

    DOMHTMLLinkElement* linkElement = nil;
    for ( DOMHTMLElement* _HTMLElem in self->_toBeCastrated )
        {
        if ( [ _HTMLElem isKindOfClass: [ DOMHTMLLinkElement class ] ] )
            {
            linkElement = ( DOMHTMLLinkElement* )_HTMLElem;
            break;
            }
        }

    DOMHTMLDivElement* h2Child = ( DOMHTMLDivElement* )( self->_toctitleElement.firstElementChild );
    [ h2Child setIdName: @"purewikied-toctitle" ];

    DOMNamedNodeMap* attrsOfHlistTableDataElement = [ self->_hlistTableDataElement attributes ];
    for ( int _Index = 0; _Index < attrsOfHlistTableDataElement.length; _Index++ )
        {
        DOMAttr* attr = ( DOMAttr* )[ attrsOfHlistTableDataElement item: _Index ];
        if ( [ attr.name isEqualToString: @"style" ] )
            [ attrsOfHlistTableDataElement removeNamedItem: @"style" ];
        }

    // Get the string representation of the current DOM tree
    NSURL* mainResourceURL = _Frame.dataSource.request.URL;
    NSString* sourceCSS = [ NSString stringWithContentsOfURL: self->_cssLabURL encoding: NSUTF8StringEncoding error: nil ];

    DOMHTMLStyleElement* newStyleElement = ( DOMHTMLStyleElement* )[ self->_styleElement cloneNode: YES ];
    [ newStyleElement setClassName: @"purewikied-css" ];
    [ newStyleElement setIdName: @"" ];
    [ ( DOMText* )( newStyleElement.firstChild ) replaceWholeText: sourceCSS ];
    [ self->_headElement appendChild: newStyleElement ];

    NSString* sourceHTML = [ document.documentElement outerHTML ];
    NSData* sourceHTMLDataRef = [ sourceHTML dataUsingEncoding: NSUTF8StringEncoding ];

    WebResource* newMainResource = [ [ WebResource alloc ] initWithData: sourceHTMLDataRef URL: mainResourceURL MIMEType: @"text/html" textEncodingName: @"utf-8" frameName: @"" ];

    WebArchive* oldWebArchive = _Frame.dataSource.webArchive;
    WebArchive* castratedWebArchive = [ [ WebArchive alloc ] initWithMainResource: newMainResource subresources: [ oldWebArchive subresources ] subframeArchives: oldWebArchive.subframeArchives ];

    return [ PWWikiPageArchive wikiPageArchiveWithTitle: self->_firstHeading webArchive: castratedWebArchive ];
    }

- ( NSURL* ) castrateFrameOnDisk: ( WebFrame* )_Frame
                           error: ( NSError* __autoreleasing* )_Error
                         archive: ( PWWikiPageArchive* __autoreleasing* )_WikiPageArchive
    {
    PWWikiPageArchive* castratedArchive = [ self castrateFrameInMemory: _Frame ];

    NSString* lastPathComponent = [ NSString stringWithFormat: @"%@-%@", _Frame.dataSource.request.URL.absoluteString, PWTimestamp() ];
    lastPathComponent = PWSignWithHMACSHA1( lastPathComponent, PWNonce() );

    // Returns a new last path component made from the reciever itself
    // by replacing all characters not in the alphanumeric character set
    // with precent encoded characters
    lastPathComponent = [ lastPathComponent stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet alphanumericCharacterSet ] ];

    NSURL* resultURL = [ self._archiveBaseURL URLByAppendingPathComponent: lastPathComponent ];
    resultURL = [ resultURL URLByAppendingPathExtension: @"webarchive" ];
    [ castratedArchive.wikiPageWebArchive.data writeToURL: resultURL options: NSDataWritingAtomic error: _Error ];

    if ( _WikiPageArchive )
        *_WikiPageArchive = castratedArchive;

    return resultURL;
    }

- ( void ) cleanUpCache
    {
    NSError* error = nil;

    NSString* archiveBasePath = self._archiveBasePathWithoutCreation;

    BOOL isDir = NO;
    BOOL itemExists = [ self->_fileManager fileExistsAtPath: archiveBasePath isDirectory: &isDir ];
    BOOL isDeletable = itemExists && isDir;


    #if DEBUG
    NSLog( @"\n>>> (Info) PureWiki is going to be terminated, the …/Cache/archives directory is %@\n"
           @"   >>> Is dir: %d\n"
           @"   >>> Itme exits: %d\n"
           @"   >>> So is it deletable? %d\n"
         , isDeletable ? @"deletable✅" : @"undeletable❌"
         , isDir, itemExists, isDeletable
         );
    #endif

    if ( isDeletable )
        [ self->_fileManager removeItemAtPath: archiveBasePath error: &error ];

    if ( error )
        NSLog( @">>> (Error❌) Occured in %s: %@", __PRETTY_FUNCTION__, error );
    }

#pragma mark Private Interfaces
@dynamic _archiveBasePath;
@dynamic _archiveBaseURL;

@dynamic _archiveBasePathWithoutCreation;
@dynamic _archiveBaseURLWithoutCreation;

- ( NSString* ) _archiveBasePath
    {
    return self._archiveBaseURL.filePathRep;
    }

- ( NSURL* ) _archiveBaseURL
    {
    NSError* error = nil;

    NSURL* cacheURL = [ self _archiveBaseURLWithoutCreation ];
    if ( cacheURL )
        {
        NSString* pathOfCacheURL = cacheURL.filePathRep;

        BOOL isDir = NO;
        BOOL itemExists = [ self->_fileManager fileExistsAtPath: pathOfCacheURL isDirectory: &isDir ];

        if ( ( itemExists && !isDir ) || !itemExists )
            {
            if ( !isDir )
                [ self->_fileManager removeItemAtPath: pathOfCacheURL error: &error ];

            [ self->_fileManager createDirectoryAtPath: pathOfCacheURL withIntermediateDirectories: NO attributes: nil error: &error ];
            }
        }

    if ( error )
        NSLog( @">>> (Error❌) Occured in %s: %@", __PRETTY_FUNCTION__, error );

    return cacheURL;
    }

- ( NSString* ) _archiveBasePathWithoutCreation
    {
    return self._archiveBaseURLWithoutCreation.filePathRep;
    }

- ( NSURL* ) _archiveBaseURLWithoutCreation
    {
    NSError* error = nil;

    NSURL* resultUrl = nil;
    NSURL* tmp = [ self->_fileManager URLForDirectory: NSCachesDirectory
                                             inDomain: NSUserDomainMask
                                    appropriateForURL: nil
                                               create: NO
                                                error: &error ];
    if ( !error )
        resultUrl = [ tmp URLByAppendingPathComponent: @"archives" isDirectory: YES ];
    else
        NSLog( @"❌Error Occured in %s: %@", __PRETTY_FUNCTION__, error );

    return resultUrl;
    }

- ( void ) _traverseNamedNodeMap: ( DOMNode* )_DOMNode
    {
    DOMNamedNodeMap* attrs = [ _DOMNode attributes ];

    for ( int _Index = 0; _Index < attrs.length; _Index++ )
        {
        DOMAttr* attr = ( DOMAttr* )[ attrs item: _Index ];

        if ( attr.childNodes.length > 0 )
            [ self _traverseNamedNodeMap: attr ];
        }
    }

- ( void ) _traverseDOMNodes: ( DOMNode* )_DOMNode
    {
    DOMNodeList* nodeList = [ _DOMNode childNodes ];

    for ( int _Index = 0; _Index < nodeList.length; _Index++ )
        {
        DOMNode* node = [ nodeList item: _Index ];

        NSString* className = [ ( DOMHTMLElement* )node className ];
        if ( [ className isEqualToString: @"mw-editsection" ]
                || [ className isEqualToString: @"toctoggle" ]
                || [ className isEqualToString: @"printfooter" ]
                || [ className isEqualToString: @"metadata plainlinks mbox-small" ]
                || [ className isEqualToString: @"mbox-small plainlinks sistersitebox" ] )
            [ self->_toBeCastrated addObject: node ];

        if ( [ node respondsToSelector: @selector( idName ) ] )
            {
            NSString* idName = [ ( DOMHTMLElement* )node idName ];
            if ( [ idName isEqualToString: @"mw-navigation" ]
                    || [ idName isEqualToString: @"footer" ]
                    || [ idName isEqualToString: @"siteSub" ]
                    || [ idName isEqualToString: @"mw-head-base" ]
                    || [ idName isEqualToString: @"mw-page-base" ]
                    || [ idName isEqualToString: @"toc" ] )
                [ self->_toBeCastrated addObject: node ];

            if ( [ idName isEqualToString: @"firstHeading" ]
                    && [ className isEqualToString: @"firstHeading" ] )
                {
                DOMNodeList* htmlCollection = [ node childNodes ];
                self->_firstHeading = [ ( DOMText* )[ htmlCollection item: 0 ] wholeText ];
                }
            }

        // <head>
        if ( [ node isKindOfClass: [ DOMHTMLHeadElement class ] ] )
            self->_headElement = ( DOMHTMLHeadElement* )node;

        // <style>
        if ( [ node isKindOfClass: [ DOMHTMLStyleElement class ] ] )
            self->_styleElement = ( DOMHTMLStyleElement* )node;

        // <div>
        if ( [ node isKindOfClass: [ DOMHTMLDivElement class ] ] )
            if ( [ [ ( DOMHTMLDivElement* )node idName ] isEqualToString: @"toctitle" ] )
                self->_toctitleElement = ( DOMHTMLDivElement* )node;

        // <td>
        if ( [ node isKindOfClass: [ DOMHTMLTableCellElement class ] ] )
            if ( [ [ ( DOMHTMLTableCellElement* )node className ] isEqualToString: @"hlist" ] )
                self->_hlistTableDataElement = ( DOMHTMLTableCellElement* )node;

        // <link>
        if ( [ node isKindOfClass: [ DOMHTMLLinkElement class ] ] )
            {
            DOMHTMLLinkElement* linkElement = ( DOMHTMLLinkElement* )node;

            if ( [ linkElement.parentElement isKindOfClass: [ DOMHTMLHeadElement class ] ] )
                {
                DOMNamedNodeMap* attrs = [ linkElement attributes ];
                for ( int _Index = 0; _Index < attrs.length; _Index++ )
                    {
                    NSString* attrName = [ attrs item: _Index ].nodeName;
                    NSString* attrValue = [ attrs item: _Index ].nodeValue;

                    if ( [ attrName isEqualToString: @"rel" ] && [ attrValue isEqualToString: @"stylesheet" ] )
                        [ self->_toBeCastrated addObject: linkElement ];
                    }
                }
            }

        // <table>
        if ( [ node isKindOfClass: [ DOMHTMLTableElement class ] ] )
            {
            DOMHTMLTableElement* HTMLTable = ( DOMHTMLTableElement* )node;
            DOMHTMLCollection* rowsCollection = [ HTMLTable rows ];

            for ( int _Index = 0; _Index < rowsCollection.length; _Index++ )
                {
                DOMHTMLTableRowElement* rowElement = ( DOMHTMLTableRowElement* )[ rowsCollection item: _Index ];

                DOMHTMLCollection* cells = [ rowElement cells ];
                for ( int _Index = 0; _Index < cells.length; _Index++ )
                    {
                    // TODO:
                    }
                }
            }

        if ( node.childNodes.length > 0 )
            {
            [ self _traverseDOMNodes: node ];
            [ self _traverseNamedNodeMap: node ];
            }
        }
    }

#pragma mark Conforms to <NSFileManagerDelegate>
- ( BOOL )      fileManager: ( nonnull NSFileManager* )_FileManager
    shouldProceedAfterError: ( nonnull NSError* )_Error
         removingItemAtPath: ( nonnull NSString* )_Path
    {
    return YES;
    }

@end // PWCastrateFactory class

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