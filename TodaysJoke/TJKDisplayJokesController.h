//
//  TJKDisplayJokesController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJKJokeItem.h"
#import "TJKJokeItemStore.h"

@interface TJKDisplayJokesController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

#pragma properties
@property (nonatomic, strong) NSMutableArray<TJKJokeItem*> *pageJokes;
@property (nonatomic) NSInteger jokeIndex;
@property (nonatomic) BOOL areFavoriteJokes;

@end
