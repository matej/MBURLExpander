//
//  URLExpanderAppDelegate.m
//  URLExpander
//
//  Created by Matej Bukovinski on 21.11.10.
//  Copyright 2010 bukovinski.com. All rights reserved.
//

#import "URLExpanderAppDelegate.h"
#import "URLExpanderViewController.h"
#import "MBURLExpander.h"

@implementation URLExpanderAppDelegate

#pragma mark -
#pragma mark Accessors

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Make sure the cache is stored to flash
    [[MBURLExpander sharedExpander] synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Make sure the cache is stored to flash
	[[MBURLExpander sharedExpander] synchronize];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {

}

@end
