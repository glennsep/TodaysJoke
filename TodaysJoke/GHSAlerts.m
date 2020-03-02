//
//  GHSAlerts.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/28/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "GHSAlerts.h"

@implementation GHSAlerts

#pragma Initializers

// designated initializer
-(instancetype)initWithViewController:(UIViewController *)vc
{
    // call super class
    [self superclass];
 
    // set the view controller
    if (self)
    {
        _callingViewController = vc;
    }
    
    // return the instance of this class
    return self;
}

// do not use init
-(instancetype)init
{
    [NSException raise:@"init Invalid"
                format:@"Use + [GHSAlerts initWithViewController"];
    return nil;
}

#pragma Methods

// display an alert dialog with an error message
-(void)displayErrorMessage:(NSString *)title errorMessage:(NSString *)message
{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:nil];
    
    [errorAlert addAction:ok];
    [_callingViewController presentViewController:errorAlert animated:YES completion:nil];
    return;
}

// display an alert dialog with an error message and an action
-(void)displayErrorMessage:(NSString *)title errorMessage:(NSString *)message errorAction:(errorActionBlock)errorBlock
{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:errorBlock];
    
    [errorAlert addAction:ok];
    [_callingViewController presentViewController:errorAlert animated:YES completion:nil];
    return;
}


@end
