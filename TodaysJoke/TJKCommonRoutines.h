//
//  TJKCommonRoutines.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/30/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJKCommonRoutines : NSObject

#pragma Methods for Navigation
-(void)setupNavigationBarTitle:(UINavigationController *)navController setTitle:(NSString *)title;
-(void)setupNavigationBarTitle:(UINavigationItem *)navItem setImage:(NSString *)image;
-(void)setupNavigationBarTitle:(UINavigationController *)navController fontName:(NSString *)fontName fontSize:(CGFloat)fontSize;
-(UIColor *)standardNavigationBarColor;
-(UIColor *)standardNavigationBarTitleColor;

#pragma Methods for screen fonts, sizes, and colors
-(UIColor *)standardSystemColor;
-(UIColor *)labelColor;
-(UIColor *)textColor;
-(UIColor *)categoryColor;
-(UIColor *)NavigationBarColor;
-(UIColor *)searchBarPlaceHolderColor;
-(void)setBorderForTextView:(UITextView *)textView;

#pragma Date functions
-(NSDate *)searchDateForQuery;
-(NSString *)getCurrentDate;

#pragma Cache Methods
-(void)retrieveCategories:(NSCache *) cacheLists;
-(void)retrieveCategoriesForPicker:(NSCache *) cacheLists;
@end
