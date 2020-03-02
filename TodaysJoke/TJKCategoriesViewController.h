//
//  TJKCategoriesViewController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/3/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import "TJKConstants.h"

@interface TJKCategoriesViewController : UIViewController

#pragma Properties
@property (nonatomic, strong) NSCache *cacheLists;

@end
