//
//  TJKCategories.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/6/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface TJKCategories : NSObject

#pragma Properties

@property (nonatomic, copy) UIImage *categoryImage;
@property (nonatomic, copy) NSString *categoryName;

#pragma Initializers
+(instancetype)initWithCategory:(NSString *)categoryName
                  categoryImage:(CKAsset *)categoryImageAsset;


-(instancetype)initWithCategory:(NSString *)categoryName
                  categoryImage:(CKAsset *)categoryImageAsset;


@end
