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

#import "PWDataRepository.h"

// PWDataRepository class
@implementation PWDataRepository

#pragma mark Initializations
+ ( instancetype ) sharedDataRepository
    {
    return [ [ self alloc ] init ];
    }

id static __sSharedDataRepository;
- ( instancetype ) init
    {
    if ( !__sSharedDataRepository )
        {
        if ( self = [ super init ] )
            __sSharedDataRepository = self;
        }

    return __sSharedDataRepository;
    }

- ( void ) awakeFromNib
    {
    NSLog( @"%@", self.applicationDocumentsDirectory );
    NSLog( @"%@", self.managedObjectModel );
    NSLog( @"%@", self.persistentStoreCoordinator );
    NSLog( @"%@", self.managedObjectContext );
    }

#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- ( NSURL* ) applicationDocumentsDirectory
    {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "home.bedroom.TongKuo.CoreDataPlayground" in the user's Application Support directory.
    NSURL* appSupportURL = [ [ [ NSFileManager defaultManager ] URLsForDirectory: NSApplicationSupportDirectory inDomains: NSUserDomainMask ] lastObject ];
    return [ appSupportURL URLByAppendingPathComponent: @"home.bedroom.TongKuo.CoreDataPlayground" ];
    }

- ( NSManagedObjectModel* ) managedObjectModel
    {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if ( _managedObjectModel )
        return _managedObjectModel;
	
    NSURL* modelURL = [ [ NSBundle mainBundle ] URLForResource: @"PureWiki" withExtension: @"momd" ];
    _managedObjectModel = [ [ NSManagedObjectModel alloc ] initWithContentsOfURL: modelURL ];
    return _managedObjectModel;
    }

- ( NSPersistentStoreCoordinator* ) persistentStoreCoordinator
    {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if ( _persistentStoreCoordinator )
        return _persistentStoreCoordinator;
    
    NSFileManager* fileManager = [ NSFileManager defaultManager ];
    NSURL* applicationDocumentsDirectory = [ self applicationDocumentsDirectory ];
    BOOL shouldFail = NO;
    NSError* error = nil;
    NSString* failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary* properties = [ applicationDocumentsDirectory resourceValuesForKeys: @[ NSURLIsDirectoryKey ] error: &error ];
    if ( properties )
        {
        if ( ![ properties[ NSURLIsDirectoryKey ] boolValue ] )
            {
            failureReason = [ NSString stringWithFormat: @"Expected a folder to store application data, found a file (%@).", [ applicationDocumentsDirectory path ] ];
            shouldFail = YES;
            }
        }

    else if ( [ error code ] == NSFileReadNoSuchFileError )
        {
        error = nil;
        [ fileManager createDirectoryAtPath: [ applicationDocumentsDirectory path ] withIntermediateDirectories: YES attributes: nil error: &error ];
        }
    
    if ( !shouldFail && !error )
        {
        NSPersistentStoreCoordinator* coordinator = [ [ NSPersistentStoreCoordinator alloc ] initWithManagedObjectModel: [ self managedObjectModel ] ];
        NSURL* url = [ applicationDocumentsDirectory URLByAppendingPathComponent: @"caches.sqlite" ];

        if ( ![ coordinator addPersistentStoreWithType: NSSQLiteStoreType configuration: nil URL: url options: nil error: &error ] )
            coordinator = nil;

        _persistentStoreCoordinator = coordinator;
        }
    
    if ( shouldFail || error )
        {
        // Report any error we got.
        NSMutableDictionary* dict = [ NSMutableDictionary dictionary ];
        dict[ NSLocalizedDescriptionKey ] = @"Failed to initialize the application's saved data";
        dict[ NSLocalizedFailureReasonErrorKey ] = failureReason;

        if ( error )
            dict[ NSUnderlyingErrorKey ] = error;

        error = [ NSError errorWithDomain: @"YOUR_ERROR_DOMAIN" code: 9999 userInfo: dict ];
        [ [ NSApplication sharedApplication ] presentError: error ];
        }

    return _persistentStoreCoordinator;
    }

- ( NSManagedObjectContext* ) managedObjectContext
    {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if ( _managedObjectContext )
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator* coordinator = [ self persistentStoreCoordinator ];
    if ( !coordinator )
        return nil;

    _managedObjectContext = [ [ NSManagedObjectContext alloc ] initWithConcurrencyType: NSMainQueueConcurrencyType ];
    [ _managedObjectContext setPersistentStoreCoordinator: coordinator ];

    return _managedObjectContext;
    }

@end // PWDataRepository class

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