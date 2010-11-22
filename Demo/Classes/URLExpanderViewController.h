//
//  URLExpanderViewController.h
//  URLExpander
//
//  Created by Matej Bukovinski on 21.11.10.
//  Copyright 2010 bukovinski.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URLExpanderViewController : UIViewController {
	UITextField *_longField;
	UITextField *_shortField;
	UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, retain) IBOutlet UITextField *longField;
@property (nonatomic, retain) IBOutlet UITextField *shortField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)expand:(id)sender;

@end

