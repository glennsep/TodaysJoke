//
//  TJKLeftPanelViewController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftPanelViewControllerDelegate <NSObject>

@optional
- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator;
- (void)textSelected:(NSString *)text;

@end

@interface TJKLeftPanelViewController : UIViewController

#pragma Properties
@property (nonatomic, assign) id<LeftPanelViewControllerDelegate> delegate;
@property (nonatomic, strong) NSCache *cacheLists;

@end
