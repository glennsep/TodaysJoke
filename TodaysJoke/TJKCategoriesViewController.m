//
//  TJKCategoriesViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/3/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKCategoriesViewController.h"
#import "TJKListJokesViewController.h"
#import "TJKAppDelegate.h"
#import "TJKCategories.h"
#import "GHSAlerts.h"
#import "TJKCommonRoutines.h"
#import "TJKConstants.h"
#import "TJKJokeItem.h"
#import "TJKJokeItemStore.h"

@interface TJKCategoriesViewController () 

@property (nonatomic, weak) IBOutlet UITableView *categoriesTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellCategories;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSMutableArray *jokeCategories;
@property (strong, nonatomic) NSString * selectedCategoryName;
@property (strong, nonatomic) UIColor *categoryColor;
@property (nonatomic) CGFloat currentBrightness;
@end

@implementation TJKCategoriesViewController

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

#pragma View Controller Methods

// routines to run when view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // store current brightness
    _currentBrightness = [UIScreen mainScreen].brightness;
    
    // get all categories
    [self retrieveCategories];
}

// routines to run when view appears
-(void)viewWillAppear:(BOOL)animated
{
    // set the title and color
    // setup scren title
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.navigationController.navigationBar.tintColor = [common NavigationBarColor];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"Categories.png"];
    
    // set the category names color
    self.categoryColor = [common textColor];
    
    // remove any joke items
    [[TJKJokeItemStore sharedStore] removeAllItems];
}

#pragma Methods

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

// retrieve categories
-(void)retrieveCategories
{
    if ([self.cacheLists objectForKey:CACHE_CATEGORY_LIST])
    {
        // retrieve categories from cache and setup table
        _jokeCategories = [self.cacheLists objectForKey:CACHE_CATEGORY_LIST];
        [self setupTableContents];
    }
    else
    {
        // start indicator
        [self startIndicator];
        
        // get all categories
        _jokeCategories = [[NSMutableArray alloc] init];
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
                     [_jokeCategories addObject:categories];
                 }
                 
                 // store categories to cache
                 [self.cacheLists setObject:_jokeCategories forKey:CACHE_CATEGORY_LIST];
                 
                 // setup table
                 [self setupTableContents];
             }
             else
             {
                 // display alert message and pop the view controller from the stack
                 // instantiate the alert object
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self stopIndicator];
                 });
                 GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                 errorActionBlock errorBlock = ^void(UIAlertAction *action) {[self closeCategories:self];};
                 [alert displayErrorMessage:@"Oops!" errorMessage:@"The joke categories failed to load. Check your network, wifi, and iCloud settings and try again." errorAction:errorBlock];
             }
         }];
    }
}

// setup the array that will hold the table's contents
-(void)setupTableContents
{   
    // store to property and reload the table contents
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.categoriesTableView reloadData];
        [self stopIndicator];
    });
}

// close the category screen
-(void)closeCategories:(id)sender
{
    // pop the view controller from the stack
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Table View Methods

// indicate the number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// indicate the number of rows in section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_jokeCategories count];
}

// set the row height to fit the images
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// display the contents of the table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellMainNibId = @"cellCategories";
    
    _cellCategories = [tableView dequeueReusableCellWithIdentifier:cellMainNibId];
    if (_cellCategories == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TJKCategoriesCell" owner:self options:nil];
    }
    
    // place button image in cell's accessory indicator
    _cellCategories.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:RIGHT_ARROW]];
    
    // create the objects to populate the cell
    UIImageView *categoryImage = (UIImageView *)[_cellCategories viewWithTag:1];
    UILabel *categoryName = (UILabel *)[_cellCategories viewWithTag:2];
    
    if ([_jokeCategories count] > 0)
    {
        TJKCategories *currentRecord = [self.jokeCategories objectAtIndex:indexPath.row];
        
        categoryName.text = [NSString stringWithFormat:@"%@", currentRecord.categoryName];
        [categoryName setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
        [categoryName setTextColor:self.categoryColor];
        categoryImage.image = currentRecord.categoryImage;
        self.selectedCategoryName = categoryName.text;
    }
    
    return _cellCategories;
}

// display the list of categories
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // setup call to list jokes table
    TJKListJokesViewController *listJokesController = [[TJKListJokesViewController alloc] init];
    TJKCategories *currentCell = [self.jokeCategories objectAtIndex:indexPath.row];
    listJokesController.categoryName = currentCell.categoryName;
    
    // push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:listJokesController animated:YES];
    
    // de-select the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
