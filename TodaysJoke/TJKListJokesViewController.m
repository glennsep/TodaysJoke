//
//  TJKListJokesViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/11/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKListJokesViewController.h"
#import "TJKDisplayJokesController.h"
#import "TJKAppDelegate.h"
#import "TJKJokeItemStore.h"
#import "TJKJokeItem.h"
#import "GHSAlerts.h"
#import "TJKConstants.h"
#import "TJKCommonRoutines.h"

@interface TJKListJokesViewController ()

#pragma Properties
@property (weak, nonatomic) IBOutlet UITableView *listJokesTableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellJokeList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSArray<TJKJokeItem*> *jokeList;
@property (nonatomic, strong) UIColor *jokeTextColor;
@property (nonatomic, strong) UIColor *jokeCategoryColor;
@property (nonatomic, strong) NSDate *searchDate;
@property (nonatomic) CGFloat currentBrightness;
@end

@implementation TJKListJokesViewController

#pragma Initializers

// init the NIB
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma View controller methods

// routines to run when view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // store current brightness
    _currentBrightness = [UIScreen mainScreen].brightness;
    
    // get the date to search for jokes
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.searchDate = [common searchDateForQuery];
    
    // retrieve all of the jokes
    [[TJKJokeItemStore sharedStore] retrieveFavoritesFromArchive];
      
    // get all the jokes for the category
    [self fetchJokesForCategory];
}

// routines to run when view appears
-(void)viewWillAppear:(BOOL)animated
{
    // retrieve all of the jokes
    [[TJKJokeItemStore sharedStore] retrieveFavoritesFromArchive];
    
    // set the title
    self.title = self.categoryName;
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.navigationController.navigationBar.tintColor = [common NavigationBarColor];
    [common setupNavigationBarTitle:self.navigationController fontName:FONT_NAME_HEADER fontSize:FONT_SIZE_HEADER];
    
    // set the joke text color in the table
    self.jokeTextColor = [common textColor];
    self.jokeCategoryColor = [common categoryColor];
    
    // reload the table data
    self.jokeList = [[TJKJokeItemStore sharedStore] allItems];
    [self.listJokesTableView reloadData];
}

#pragma Methods

// set the table contents
-(void)setupTableContents
{
    // store to property and reload the table contents
    dispatch_async(dispatch_get_main_queue(), ^{
        self.jokeList = [[TJKJokeItemStore sharedStore] allItems];
        [self.listJokesTableView reloadData];
        [self stopIndicator];
    });
}

// start activity indicator
-(void)startIndicator
{
    // declare variables
    CGFloat screenDimmer = SCREEN_DIM;
    
    // check if screenDimmer is greater than the current screen brightness
    if (screenDimmer >= _currentBrightness)
    {
        screenDimmer = _currentBrightness / REDUCE_BRIGHTNESS_FACTOR;
    }
    
    self.navigationItem.hidesBackButton = YES;
    [[UIScreen mainScreen] setBrightness:screenDimmer];
    [self.activityIndicatorView startAnimating];
}

// stop activity indicator
-(void)stopIndicator
{
    self.navigationItem.hidesBackButton = NO;
    [[UIScreen mainScreen] setBrightness:_currentBrightness];
    [self.activityIndicatorView stopAnimating];
}

// retrieve all the jokes that belong to the selected category
-(void)fetchJokesForCategory
{
    // determine if jokes are fetched for a single or all categories
    if (self.searchForJokes == YES)
    {
        [self fetchJokesBySearch];
    }
    else if ([self.categoryName isEqualToString:CATEGORY_TO_REMOVE_RANDOM])
    {
        [self fetchJokesForAllCategories];
    }
    else if ([self.categoryName isEqualToString:CATEGORY_FIELD_FAVORITE])
    {
        [self fetchFavoriteJokes];
    }
    else
    {
        [self fetchJokesForSingleCategory];
    }
}

// get jokes by search keyword
-(void)fetchJokesBySearch
{
    // declare variables
    __block NSUInteger counter = 0;             // counts number of jokes found to determine when to load table
    
    NSDate * todaysDate = [NSDate date];
    
    // start indicator
    [self startIndicator];
    
    // retrieve the record information for the joke category
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateSearch = [NSPredicate predicateWithFormat:@"(self CONTAINS %@) && (jokeDisplayDate <= %@)", self.searchText.lowercaseString, self.searchDate];
    CKQuery *querySearch = [[CKQuery alloc] initWithRecordType:JOKE_RECORD_TYPE predicate:predicateSearch];
    NSSortDescriptor *sortJokes = [[NSSortDescriptor alloc] initWithKey:JOKE_CREATED_SYSTEM ascending:NO];
    querySearch.sortDescriptors = [NSArray arrayWithObjects:sortJokes, nil];
    [jokePublicDatabase performQuery:querySearch inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error)
     {
         if (!error)
         {
            // check if no results found
            if (results.count == 0)
            {
                // remvove indicator
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopIndicator];
                });
                
                
                // indicate that no joke was found
                [[TJKJokeItemStore sharedStore] createItem:NO_JOKES_FOUND jokeCategory:CATEGORY_NONE nameSubmitted:@"" jokeTitle:NO_JOKES_FOUND categoryRecordName:@"" jokeCreated:todaysDate jokeRecordName:@""];
                [self setupTableContents];
                
            }
            else
            {
                // loop through all joke records
                for (CKRecord *jokeRecord in results)
                {
                    // get the category for the joke record
                    CKReference *referenceToCategory = jokeRecord[CATEGORY_FIELD_NAME];
                    CKRecordID *categoryRecordID = referenceToCategory.recordID;
                    [jokePublicDatabase fetchRecordWithID:categoryRecordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error)
                     {
                        // add the joke to the joke item store (array)
                        [[TJKJokeItemStore sharedStore] createItem:[jokeRecord objectForKey:JOKE_DESCR] jokeCategory:[record objectForKey:CATEGORY_FIELD_NAME] nameSubmitted:[jokeRecord objectForKey:JOKE_SUBMITTED_BY] jokeTitle:[jokeRecord objectForKey:JOKE_TITLE] categoryRecordName:[jokeRecord valueForKey:CATEGORY_FIELD_NAME] jokeCreated:[jokeRecord valueForKey:JOKE_CREATED] jokeRecordName:jokeRecord.recordID.recordName];
                         
                         // setup the table
                         if (++counter == results.count)
                         {
                             [self setupTableContents];
                         }
                     }];
                }
            }
          }
          else
          {
              // instantiate the alert object
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self stopIndicator];
              });
              GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
              [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the search criteria. Check your network, wifi, and iCloud settings and try again."];
              return;
          }
      }];
}

// get jokes for a single category
-(void)fetchJokesForSingleCategory
{
    // start indicator
    [self startIndicator];
    
    // retrieve the record information for the joke category
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategories = [NSPredicate predicateWithFormat:@"CategoryName == %@", self.categoryName];
    CKQuery *queryCategories = [[CKQuery alloc] initWithRecordType:CATEGORY_RECORD_TYPE predicate:predicateCategories];
    [jokePublicDatabase performQuery:queryCategories inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error)
     {
         if (!error)
         {
             // get the first record as there should only be one record per category
             CKRecord *categoryRecord = [results firstObject];

             // if the category is found load jokes for category
             if (categoryRecord)
             {
                 // now that we have the record id for the joke category get the jokes
                 NSPredicate *predicateJokes = [NSPredicate predicateWithFormat:@"CategoryName == %@ && jokeDisplayDate <= %@",categoryRecord, self.searchDate];
                 CKQuery *jokeQuery = [[CKQuery alloc] initWithRecordType:JOKE_RECORD_TYPE predicate:predicateJokes];
                 NSSortDescriptor *sortJokes = [[NSSortDescriptor alloc] initWithKey:JOKE_CREATED_SYSTEM ascending:NO];
                 jokeQuery.sortDescriptors = [NSArray arrayWithObjects:sortJokes, nil];
                 [jokePublicDatabase performQuery:jokeQuery inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * results, NSError * error)
                  {
                      if (!error)
                      {
                          for (CKRecord *jokeRecord in results)
                          {
                              // add the joke to the joke item store (array)
                              [[TJKJokeItemStore sharedStore] createItem:[jokeRecord objectForKey:JOKE_DESCR] jokeCategory:self.categoryName nameSubmitted:[jokeRecord objectForKey:JOKE_SUBMITTED_BY] jokeTitle:[jokeRecord objectForKey:JOKE_TITLE] categoryRecordName:[jokeRecord valueForKey:CATEGORY_FIELD_NAME] jokeCreated:[jokeRecord valueForKey:JOKE_CREATED] jokeRecordName:jokeRecord.recordID.recordName];
                          }
                          
                          // setup the table
                          [self setupTableContents];
                      }
                      else
                      {
                          // instantiate the alert object
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self stopIndicator];
                          });
                          GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
                          [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the category. Check your network, wifi, and iCloud settings and try again."];
                          return;
                      }
                  }];
             }
         }
         else
         {
             // instantiate the alert object
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self stopIndicator];
             });
             GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
             [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the category. Check your network, wifi, and iCloud settings and try again."];
             return;
         }
     }];
}

// get favorite jokes
-(void)fetchFavoriteJokes
{
    // start indicator
    [self startIndicator];
    
    // remove any joke items
    [[TJKJokeItemStore sharedStore] removeAllItems];
    
    // get all the favorite jokes
    NSArray *favorites = [[TJKJokeItemStore sharedStore] retrieveFavoritesFromStore];
    
    // loop through favorites and add jokes to the joke item store
    for (id jokeRecord in favorites)
    {
        // add the joke to the joke item store (array)
        [[TJKJokeItemStore sharedStore] createItem:[jokeRecord valueForKey:JOKE_DESCR] jokeCategory:[jokeRecord valueForKey:JOKE_CATEGORY] nameSubmitted:[jokeRecord valueForKey:JOKE_NAME_SUBMITTED] jokeTitle:[jokeRecord valueForKey:JOKE_TITLE] categoryRecordName:[jokeRecord valueForKey:CATEGORY_RECORD_NAME] jokeCreated:[jokeRecord valueForKey:JOKE_DATE] jokeRecordName:[jokeRecord valueForKey:JOKE_ID]];
    }
    
    // randomize the jokes
    [[TJKJokeItemStore sharedStore] randomizeItems];
    
    // setup the table
    [self setupTableContents];
}

// get jokes for all categories
-(void)fetchJokesForAllCategories
{
    // start indicator
    [self startIndicator];
    
    // retrieve the record information for the joke category
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategories = [NSPredicate predicateWithFormat:@"CategoryName != %@", CATEGORY_ALL];
    CKQuery *queryCategories = [[CKQuery alloc] initWithRecordType:CATEGORY_RECORD_TYPE predicate:predicateCategories];
    [jokePublicDatabase performQuery:queryCategories inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error)
     {
         if (!error)
         {
             // get the first record as there should only be one record per category
             for (CKRecord *categoryRecord in results)
             {                
                 // setup the table
                 [self setupTableContents];
                 
                 if (categoryRecord)
                 {
                     // now that we have the record id for the joke category get the jokes
                     NSPredicate *predicateJokes = [NSPredicate predicateWithFormat:@"CategoryName == %@ && jokeDisplayDate <= %@",categoryRecord, self.searchDate];
                     CKQuery *jokeQuery = [[CKQuery alloc] initWithRecordType:JOKE_RECORD_TYPE predicate:predicateJokes];
                     [jokePublicDatabase performQuery:jokeQuery inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * results, NSError * error)
                      {
                          if (!error)
                          {
                              for (CKRecord *jokeRecord in results)
                              {
                                  // add the joke to the joke item store (array)
                                  [[TJKJokeItemStore sharedStore] createItem:[jokeRecord objectForKey:JOKE_DESCR] jokeCategory:[categoryRecord objectForKey:CATEGORY_FIELD_NAME] nameSubmitted:[jokeRecord objectForKey:JOKE_SUBMITTED_BY] jokeTitle:[jokeRecord objectForKey:JOKE_TITLE] categoryRecordName:[jokeRecord valueForKey:CATEGORY_FIELD_NAME] jokeCreated:[jokeRecord valueForKey:JOKE_CREATED] jokeRecordName:jokeRecord.recordID.recordName];
                              }
                              
                              // randomize the jokes
                              [[TJKJokeItemStore sharedStore] randomizeItems];
                              
                              // setup the table
                              [self setupTableContents];
                          }
                          else
                          {
                              // instantiate the alert object
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopIndicator];
                              });
                              GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
                              [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the category. Check your network, wifi, and iCloud settings and try again."];
                              return;
                          }
                      }];
                 }
             }
         }
         else
         {
             // instantiate the alert object
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self stopIndicator];
             });
             GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
             [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the category. Check your network, wifi, and iCloud settings and try again."];
             return;
         }
     }];
}

#pragma Table View Methods

// indicate the number of sections in the table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// indicate the number of rows in the section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TJKJokeItemStore sharedStore] allItems] count];
}

// set the row height to fit the images
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

// display the contents of the table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // get the cell name
    static NSString *cellMainNibId = @"cellJokeList";
    
    // get a new or recycled cell
    _cellJokeList = [tableView dequeueReusableCellWithIdentifier:cellMainNibId];
    if (_cellJokeList == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TJKListJokesCell" owner:self options:nil];
    }
    
    // place button image in cell's accessory indicator
    _cellJokeList.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:RIGHT_ARROW]];
    
    // create objects to populate the cell
    UILabel *jokeTitle = (UILabel *)[_cellJokeList viewWithTag:1];
    UILabel *jokeCategory = (UILabel *)[_cellJokeList viewWithTag:2];
    
    // retrieve all jokes
    NSArray *items = [[TJKJokeItemStore sharedStore] allItems];
    if ([items count] > 0)
    {
        TJKJokeItem *jokeItem = items[indexPath.row];
        jokeTitle.text = [NSString stringWithFormat:@"%@", jokeItem.jokeTitle];
        [jokeTitle setFont:[UIFont fontWithName:FONT_JOKE_LIST_TEXT size:FONT_JOKE_LIST_SIZE]];
        [jokeTitle setTextColor:self.jokeTextColor];
        jokeCategory.text = [NSString stringWithFormat:@"%@", jokeItem.jokeCategory];
        [jokeCategory setFont:[UIFont fontWithName:FONT_CATEGORY_TEXT size:FONT_CATEGORY_SIZE]];
        [jokeCategory setTextColor:self.jokeCategoryColor];
        
        // if the joke indicates no joke found then remove cell's accessory indicator
        if (jokeItem.jokeTitle == NO_JOKES_FOUND)
        {
            _cellJokeList.accessoryType = UITableViewCellAccessoryNone;
            _cellJokeList.accessoryView = UITableViewCellAccessoryNone;
        }
    }

    return _cellJokeList;
}

// show screen to list jokes when one is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // do not go into detail if joke list has no jokes found
    if (self.jokeList[indexPath.row].jokeTitle != NO_JOKES_FOUND)
    {
        // create instance of contact us view controller
        TJKDisplayJokesController *jokeView = [[TJKDisplayJokesController alloc] initWithNibName:nil bundle:nil];
        
        // pass the array with the jokes to the display joke controller
        jokeView.pageJokes = [NSMutableArray arrayWithArray:self.jokeList];
        jokeView.jokeIndex = indexPath.row;
        jokeView.areFavoriteJokes = ([self.categoryName isEqualToString:CATEGORY_FIELD_FAVORITE]) ? YES : NO;
        
        // display the contact us screen
        [self.navigationController pushViewController:jokeView animated:YES];
    }
    
    // de-select the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
