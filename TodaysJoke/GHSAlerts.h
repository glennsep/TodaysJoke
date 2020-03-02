//
//  GHSAlerts.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/28/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

// define error action block as a type
typedef void (^errorActionBlock)(UIAlertAction *action);

@interface GHSAlerts : UIViewController

#pragma Initializers
// designated initializer
-(instancetype)initWithViewController:(UIViewController *)vc;

#pragma Properties
// get the view controller that is calling this class
@property(nonatomic, weak) UIViewController *callingViewController;

#pragma Methods
// display an alert dialog with an error message
-(void)displayErrorMessage:(NSString *)title errorMessage:(NSString *)message;

// display an alert dialog with an error message and an action
-(void)displayErrorMessage:(NSString *)title errorMessage:(NSString *)message errorAction:(errorActionBlock)errorBlock;

@end
