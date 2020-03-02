//
//  TJKCommonRoutines.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/30/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <CloudKit/Cloudkit.h>
#import "TJKCommonRoutines.h"
#import "TJKConstants.h"
#import "TJKCategories.h"

@interface TJKCommonRoutines()

#pragma Properties
@property (nonatomic, strong) NSArray *jokeCategories;

@end

@implementation TJKCommonRoutines

#pragma Methods for navigation

// set the navigation title and color
-(void)setupNavigationBarTitle:(UINavigationController *)navController setTitle:(NSString *)title
{
    [navController.navigationBar.topItem setTitle:title];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[self standardSystemColor]}];
}

// set the navigation bar title image
-(void)setupNavigationBarTitle:(UINavigationItem *)navItem setImage:(NSString *)image
{
    UIImage *img = [UIImage imageNamed:image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,40)];
    [imageView setImage:img];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    navItem.titleView = imageView;
}

// setup the navigation title and color when a view controller is pushed to the stack
-(void)setupNavigationBarTitle:(UINavigationController *)navController fontName:(NSString *)fontName fontSize:(CGFloat)fontSize
{
    NSArray *keys = [NSArray arrayWithObjects: NSForegroundColorAttributeName, NSFontAttributeName, nil];
    NSArray *objs = [NSArray arrayWithObjects: [self standardNavigationBarTitleColor], [UIFont fontWithName:fontName size:fontSize], nil];
    navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
}

// set the stanard color for the navigation bar
-(UIColor *)standardNavigationBarColor
{
    UIColor *standardColor = [[UIColor alloc] initWithRed:248 green:248 blue:248 alpha:1];
    return standardColor;
}

// set the color for the title in the navigation bar
-(UIColor *)standardNavigationBarTitleColor
{
//    UIColor *titleColor = [[UIColor alloc] initWithRed:52/256.0 green:75/256.0 blue:105/256.0 alpha:1];
    UIColor *titleColor = [[UIColor alloc] initWithRed:52/256.0 green:75/256.0 blue:105/256.0 alpha:1];
    return titleColor;
}

#pragma Methods for screen colors, fonts, sizes

// return the stanard color used in the application
-(UIColor *)standardSystemColor
{
    UIColor *standardColor = [[UIColor alloc] initWithRed:84/256.0 green:174/256.0 blue:166/256.0 alpha:1];
    return standardColor;
}

// set the color for a label
-(UIColor *)labelColor
{
    UIColor *titleColor = [[UIColor alloc] initWithRed:84/256.0 green:174/256.0 blue:166/256.0 alpha:1];
    return titleColor;
}

// set the color for a text box
-(UIColor *)textColor
{
    UIColor *titleColor = [[UIColor alloc] initWithRed:52/256.0 green:75/256.0 blue:105/256.0 alpha:1];
    return titleColor;
}

// color for the category name
-(UIColor *)categoryColor
{
    UIColor *titleColor = [[UIColor alloc] initWithRed:255/256.0 green:80/256.0 blue:0/256.0 alpha:1];
    return titleColor;
}

// color for navigation bar
-(UIColor *)NavigationBarColor
{
    UIColor *titleColor = [[UIColor alloc] initWithRed:52/256.0 green:75/256.0 blue:105/256.0 alpha:1];
    return titleColor;
}

// color for search bar place holder
-(UIColor *)searchBarPlaceHolderColor
{
    UIColor *titleColor = [[UIColor alloc] initWithRed:180/256.0 green:251/256.0 blue:255/256.0 alpha:1];
    return titleColor;
}

// set the border for a text view
-(void)setBorderForTextView:(UITextView *)textView
{
    UIColor *borderColor = [UIColor colorWithRed:84/256.0 green:174/256.0 blue:166/256.0 alpha:1];
    UIColor *backgroundColor = [UIColor colorWithRed:0.984 green:0.898 blue:0.843 alpha:1];
    textView.layer.borderWidth = 2.0f;
    textView.layer.borderColor = borderColor.CGColor;
    textView.layer.cornerRadius = 5.0;
    textView.layer.backgroundColor = backgroundColor.CGColor;
}

#pragma Date functions

// returns the current date used when querying for jokes.
-(NSDate *)searchDateForQuery
{
    // from todays date get the current date with 23 hours, 59 minutes, and 59 seconds and in the current time zone
    NSDate *todaysDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSUIntegerMax fromDate: todaysDate];
    [components setHour: 23];
    [components setMinute: 59];
    [components setSecond: 59];
    NSDate* searchDate = [[calendar dateFromComponents:components] dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];
    return searchDate;
}

// returns the current date in the local time zone
-(NSString *)getCurrentDate
{
    NSDate* now = [NSDate date];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterFullStyle];
    NSString* dateString = [df stringFromDate:now];
    return dateString;
}

#pragma Cache Methods

// retrieve categories to list in table
-(void)retrieveCategories:(NSCache *)cacheLists
{
    // get all categories
    NSMutableArray *jokeCategories = [[NSMutableArray alloc] init];
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategory = [NSPredicate predicateWithFormat:@"CategoryName != %@", CATEGORY_TO_REMOVE_OTHER];
    CKQuery *queryCategory = [[CKQuery alloc] initWithRecordType:CATEGORY_RECORD_TYPE predicate:predicateCategory];
    NSSortDescriptor *sortCategory = [[NSSortDescriptor alloc] initWithKey:CATEGORY_FIELD_NAME ascending:YES];
    queryCategory.sortDescriptors = [NSArray arrayWithObjects:sortCategory, nil];
    [jokePublicDatabase performQuery:queryCategory inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>* results, NSError * error)
     {
         if (!error)
         {
             // add all categories to array
             for (CKRecord* jokeCategory in results)
             {
                 TJKCategories *categories = [TJKCategories initWithCategory:[jokeCategory valueForKey:CATEGORY_FIELD_NAME] categoryImage:[jokeCategory valueForKey:CATEGORY_FIELD_IMAGE]];
                 [jokeCategories addObject:categories];
             }
             
             // store categories to cache
             [cacheLists setObject:jokeCategories forKey:CACHE_CATEGORY_LIST];
         }
     }];
}

// retrieve categories to list in picker when submitting a joke
-(void)retrieveCategoriesForPicker:(NSCache *)cacheLists
{
    // get all categories
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategory = [NSPredicate predicateWithFormat:@"CategoryName != %@ && CategoryName != %@", CATEGORY_TO_REMOVE_RANDOM, CATEGORY_TO_REMOVE_FAVORITE];
    CKQuery *queryCategory = [[CKQuery alloc] initWithRecordType:CATEGORY_RECORD_TYPE predicate:predicateCategory];
    NSSortDescriptor *sortCategory = [[NSSortDescriptor alloc] initWithKey:CATEGORY_FIELD_NAME ascending:YES];
    queryCategory.sortDescriptors = [NSArray arrayWithObjects:sortCategory, nil];
    [jokePublicDatabase performQuery:queryCategory inZoneWithID:nil completionHandler:^(NSArray *results, NSError * error)
     {
         if (!error)
         {
             // load the array with joke categories
             _jokeCategories = [results valueForKey:CATEGORY_FIELD_NAME];
             
             // store categories to cache
             [cacheLists setObject:_jokeCategories forKey:CACHE_CATEGORY_PICKER];
             
         }
     }];
}

@end