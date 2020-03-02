//
//  TJKCategories.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/6/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKCategories.h"

@interface TJKCategories()

#pragma Properities
@property (nonatomic, strong) CKAsset *categoryImageAsset;

@end

@implementation TJKCategories

#pragma initializers

// desginated initializer
-(instancetype)initWithCategory:(NSString *)categoryName categoryImage:(CKAsset *)categoryImageAsset
{
    self = [super init];
    
    if (self)
    {
        self.categoryImageAsset = categoryImageAsset;
        self.categoryName = categoryName;
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:self.categoryImageAsset.fileURL.path];
        self.categoryImage = image;       
    }

    return self;
}

// class level initializer
+(instancetype)initWithCategory:(NSString *)categoryName categoryImage:(CKAsset *)categoryImageAsset
{
    TJKCategories *category = [[self alloc]initWithCategory:categoryName categoryImage:categoryImageAsset];
    return category;
}

// override default initializer
-(instancetype)init
{
    return [self initWithCategory:@"" categoryImage:nil];
}

@end
