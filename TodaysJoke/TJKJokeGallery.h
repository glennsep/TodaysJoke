//
//  TJKJokeGallery.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJKJokeGallery : UICollectionViewCell

#pragma properties
@property (nonatomic,strong) NSString *jokeDescr;
@property (nonatomic,strong) NSString *jokeCategoryText;

#pragma Methods
-(void)updateCell;

@end
