//
//  TJKListJokesViewController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/11/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import "TJKConstants.h"

@interface TJKListJokesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

#pragma Properties
@property (strong, nonatomic) NSString *categoryName;
@property (nonatomic) BOOL searchForJokes;
@property (strong, nonatomic) NSString *searchText;

@end
