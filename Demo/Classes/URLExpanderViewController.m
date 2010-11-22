//
//  URLExpanderViewController.m
//  URLExpander
//
//  Created by Matej Bukovinski on 21.11.10.
//  Copyright 2010 bukovinski.com. All rights reserved.
//

#import "URLExpanderViewController.h"
#import "MBURLExpander.h"


@implementation URLExpanderViewController

#pragma mark -
#pragma mark Accessors

@synthesize longField = _longField, shortField = _shortField, activityIndicator = _activityIndicator;

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	self.longField = nil;
	self.shortField = nil;
	self.activityIndicator = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_longField release];
	[_shortField release];
	[_activityIndicator release];
	[super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)expand:(id)sender {
	NSString *longURL = _longField.text;
	
	// A quick check if the URL is valid
	if (![NSURL URLWithString:longURL]) {
		NSLog(@"%@ does not seem to be a valid URL", longURL);
		_longField.textColor = [UIColor redColor];
		return;
	} else {
		_longField.textColor = [UIColor blackColor];
	}

	
	// Expand
	if (longURL) {
		
		[_activityIndicator startAnimating];
		
		[[MBURLExpander sharedExpander] expandURLString:longURL fetchCallback:^(NSString *URLString, NSError *error) {
			if (URLString) {
				_shortField.text = URLString;
			} else {
				NSLog(@"URL Expansion failed");
				if (error) {
					NSLog(@"Error: %@", [error localizedDescription]);
				}
			}
			[_activityIndicator stopAnimating];
		}];
	}
}

@end
