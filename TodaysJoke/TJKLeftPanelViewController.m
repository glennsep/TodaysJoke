//
//  TJKLeftPanelViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKLeftPanelViewController.h"
#import "TJKCategoriesViewController.h"
#import "TJKContactUsViewController.h"
#import "TJKSearchJokesViewController.h"
#import "TJKCommonRoutines.h"
#import "TJKConstants.h"

@interface TJKLeftPanelViewController ()

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;
@property (nonatomic, strong) NSMutableArray *tableContents;
@property (nonatomic, strong) UIColor *tableTextColor;

@end

@implementation TJKLeftPanelViewController

#pragma Initializers

// inits the NIB
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

#pragma View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup the text color in the table
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.tableTextColor = [common textColor];
   
    
    [self setupTableContents];
}

#pragma Methods

// setup the array that will hold the table's contents
-(void)setupTableContents
{
    // define array with table contents
    NSArray *tableContentsArray = @[@"Categories", @"Search", @"Contact Us"];
    
    // store to propery and reload table contents
    self.tableContents = [NSMutableArray arrayWithArray:tableContentsArray];
    [self.leftTableView reloadData];
}

// display the list of categories
-(void)callCategoriesTable
{  
    // allocate and create instance of categories view controller
    TJKCategoriesViewController *categoriesViewController = [[TJKCategoriesViewController alloc] init];
    
    // pass cache to categories view controller
    categoriesViewController.cacheLists = self.cacheLists;
    
    // push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:categoriesViewController animated:YES];
}

// display the contact us screen
-(void)displayContactUs
{
    // create instance of contact us view controller
    TJKContactUsViewController *contactUs = [[TJKContactUsViewController alloc] initWithNibName:nil bundle:nil];
    
    
    // display the contact us screen
    [self.navigationController pushViewController:contactUs animated:YES];
}

// display the contact us screen
-(void)searchJokes
{
    // create instance of contact us view controller
    TJKSearchJokesViewController *searchJokes = [[TJKSearchJokesViewController alloc] initWithNibName:nil bundle:nil];
    
    
    // display the contact us screen
    [self.navigationController pushViewController:searchJokes animated:YES];
}

#pragma Table View Methods

// indicate number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// indicate number of rows in section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableContents count];
}

// display the table contents
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellMainNibID = @"cellMain";
    
    _cellMain = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
    if (_cellMain == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TJKMainCellLeft" owner:self options:nil];
    }

    // place button image in cell's accessory indicator
    _cellMain.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:RIGHT_ARROW]];
    
    UILabel *creator = (UILabel *)[_cellMain viewWithTag:3];
    
    if ([_tableContents count] > 0)
    {
        NSString *currentRecord = [self.tableContents objectAtIndex:indexPath.row];
        creator.text = [NSString stringWithFormat:@"%@", currentRecord];
        [creator setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
        [creator setTextColor:self.tableTextColor];
    }
     
    return _cellMain;
}

// display the list of categories
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // display the selected option
    switch (indexPath.row)
    {
        // display the categories table
        case 0:
            [self callCategoriesTable];
            break;
        case 1:
            [self searchJokes];
            break;
        case 2:
            [self displayContactUs];
            break;
        default:
            NSLog(@"No options available");
    }
    
    // de-select the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
