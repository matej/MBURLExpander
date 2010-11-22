//
//  URLExpanderAppDelegate.h
//  URLExpander
//
//  Created by Matej Bukovinski on 21.11.10.
//  Copyright 2010 bukovinski.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class URLExpanderViewController;

@interface URLExpanderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    URLExpanderViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet URLExpanderViewController *viewController;

@end

