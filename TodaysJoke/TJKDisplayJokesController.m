//
//  TJKDisplayJokesController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKDisplayJokesController.h"
#import "TJKListJokesViewController.h"
#import "TJKJokeGallery.h"
#import "TJKCommonRoutines.h"
#import "TJKAppDelegate.h"

@interface TJKDisplayJokesController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) int currentIndex;
@property (nonatomic) UIImage *favoriteImage;
@property (nonatomic) CGRect favoriteFrameImg;
@property (nonatomic) UIButton *favoriteButton;

@end

@implementation TJKDisplayJokesController

#pragma Initializers

// designated initializer
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // call super class
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // set the navigation bar to indicate if favorite is selected or not
        [self setupFavoriteButton];
    }
    
    // return view controller
    return self;
}

#pragma View Controller Methods

// routine to run when view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the automatically adjust scroll view inserts to no
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // setup screen title
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"ListJokes.png"];
    
    // setup background image
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:MAIN_VIEW_BACKGROUND]];
    
    // setup the collection view by setting up how it responds and displays
    [self setupCollectionView];
}

// routines to implement when view appears
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // set joke to start at joke selected from table.
    NSIndexPath *path = [NSIndexPath indexPathForRow:_jokeIndex inSection:0];
    self.currentIndex = (int)_jokeIndex;
    [self.collectionView scrollToItemAtIndexPath:path
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    [self setupFavoriteButton];
}

#pragma Methods

// set navigation bar to indicate if favorite is selected
-(void)setupFavoriteButton
{
    // create button to indicate favorite
    // first create the image
    
    // make sure the current index doesn't exceed the number of items in the array
    if (self.currentIndex > [self.pageJokes count]-1)
    {
        self.currentIndex = (int)[self.pageJokes count] -1;
    }
    
    TJKJokeItem *joke = [self.pageJokes objectAtIndex:self.currentIndex];
    if ([[TJKJokeItemStore sharedStore] checkIfFavorite:joke] == -1)
    {
        self.favoriteImage = [UIImage imageNamed:@"favoriteUnSelected.png"];
    }
    else
    {
        if (self.areFavoriteJokes)
        {
            self.favoriteImage = [UIImage imageNamed:@"Remove.png"];
        }
        else
        {
            self.favoriteImage = [UIImage imageNamed:@"favoriteSelected.png"];
        }
    }
    if (self.areFavoriteJokes)
    {
        self.favoriteFrameImg = CGRectMake(0,0,65,40);
    }
    else
    {
        self.favoriteFrameImg = CGRectMake(0,0,25,25);
    }
    self.favoriteButton = [[UIButton alloc] initWithFrame:self.favoriteFrameImg];
    [self.favoriteButton setBackgroundImage:self.favoriteImage forState:UIControlStateNormal];
    [self.favoriteButton addTarget:self action:@selector(makeFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [self.favoriteButton setShowsTouchWhenHighlighted:NO];
    
    
    UIBarButtonItem *favoriteItem = [[UIBarButtonItem alloc] initWithCustomView:self.favoriteButton];
    self.navigationItem.rightBarButtonItem = favoriteItem;
}

// setup joke as favorite
-(void)makeFavorite:(id)sender
{   
    TJKJokeItem *joke = [self.pageJokes objectAtIndex:self.currentIndex];
    if ([[TJKJokeItemStore sharedStore] checkIfFavorite:joke] == -1)
    {
        // insert into favorite jokes collection
        [[TJKJokeItemStore sharedStore] insertFavoriteJoke:joke];
    }
    else
    {
        // remove from favorite jokes collection
        [[TJKJokeItemStore sharedStore] removeFavoriteJoke:joke];
        
        // remove the cell if we are displaying favorites
        if (self.areFavoriteJokes)
        {
            [[TJKJokeItemStore sharedStore] removeItem:joke];
            [self removeFavoriteCell:self.currentIndex];
        }
     }
    
    // save the favorite jokes
    [[TJKJokeItemStore sharedStore] saveFavoritesToArchive];
    
    // only setup if there are jokes
    if ([self.pageJokes count] > 0)
    {
        [self setupFavoriteButton];
    }
    
    // check if there are no jokes left.  If not go back to the prior table view
    if (self.areFavoriteJokes)
    {
        if ([self.pageJokes count] == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

// remove the cell if we are display favorite jokes and the favorite button was unselected
-(void)removeFavoriteCell:(int)index
{
    [self.collectionView performBatchUpdates:^{
        [self.pageJokes removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } completion:^(BOOL finished) {
        
    }];
}

// setup the collection by setting up how it responds and displays
-(void)setupCollectionView {
    [self.collectionView registerClass:[TJKJokeGallery class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
}

#pragma Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.pageJokes count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // initialize the joke gallery that contains the cell
    TJKJokeGallery *cell = (TJKJokeGallery *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
  
    // set background image
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:MAIN_VIEW_BACKGROUND]];
    
    // retrieve the joke description and category and update the cell
    TJKJokeItem *jokeItem = [self.pageJokes objectAtIndex:indexPath.row];
    
    NSString *jokeDescr = jokeItem.jokeDescr;
    NSString *jokeCategory = jokeItem.jokeCategory;
  
    cell.jokeDescr = jokeDescr;
    cell.jokeCategoryText = jokeCategory;
    [cell updateCell];
    
    // update the current index with the joke item
    self.currentIndex = (int)indexPath.row;
    [self setupFavoriteButton];
    
    return cell;
}

// size the cell when device is rotated
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat cellHeight = [[UIScreen mainScreen] bounds].size.height;

    return CGSizeMake(cellWidth,cellHeight);
}

@end
