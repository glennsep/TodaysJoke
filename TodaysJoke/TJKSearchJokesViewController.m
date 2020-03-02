//
//  TJKSearchJokesControllerViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 5/24/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKSearchJokesViewController.h"
#import "TJKListJokesViewController.h"
#import "TJKConstants.h"
#import "TJKCommonRoutines.h"
#import "TJKJokeItemStore.h"

@interface TJKSearchJokesViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBox;

@end

@implementation TJKSearchJokesViewController

#pragma Initializers
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // call super class
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {

    }
    
    // return view controller
    return self;
}

#pragma View Controller Methods

// routines to run when view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up delegate for seach bar
    self.searchBox.delegate = self;
    
    // make first letter lowercase
    self.searchBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // setup scren title
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.navigationController.navigationBar.tintColor = [common NavigationBarColor];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"SearchJokes.png"];
    
    // set background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:MAIN_VIEW_BACKGROUND]];
    
    // setup the screen layout
    [self setupScreenLayout:common];
}

// routines to run when view appears
-(void)viewWillAppear:(BOOL)animated
{
    // remove all items from joke store
    [[TJKJokeItemStore sharedStore] removeAllItems];
    
    // set search box as first responder
    [self.searchBox becomeFirstResponder];
}

#pragma Methods
// setup the screen fonts, size, and layout
-(void)setupScreenLayout:(TJKCommonRoutines *)common
{
    // setup the fon and color the fields in the screen
    self.searchBox.barTintColor = [common labelColor];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[common searchBarPlaceHolderColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[common textColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
}

#pragma Events
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // remove keyboard
    [searchBar resignFirstResponder];

    // setup call to list jokes table
    TJKListJokesViewController *listJokesController = [[TJKListJokesViewController alloc] init];
    listJokesController.searchText = searchBar.text;
    listJokesController.searchForJokes = YES;
    
    // push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:listJokesController animated:YES];
}

@end
