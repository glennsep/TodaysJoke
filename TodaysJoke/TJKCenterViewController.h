//
//  TJKCenterViewController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJKLeftPanelViewController.h"
@class TJKJokeItem;

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end


@interface TJKCenterViewController : UIViewController <LeftPanelViewControllerDelegate>

#pragma Properties
@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;
@property (nonatomic) int leftButton;
@property (strong, nonatomic) TJKJokeItem *latestJoke;

#pragma Methods
-(void)btnMovePanelRight:(id)sender;
-(void)displayLatestJoke;

@end
