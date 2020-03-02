//
//  TJKCenterViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import "TJKCenterViewController.h"
#import "TJKAppDelegate.h"
#import "TJKCommonRoutines.h"
#import "TJKConstants.h"
#import "TJKJokeItem.h"
#import "GHSAlerts.h"

@interface TJKCenterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *jokeTitle;
@property (weak, nonatomic) IBOutlet UILabel *jokeCategory;
@property (weak, nonatomic) IBOutlet UILabel *jokeSubmitted;
@property (weak, nonatomic) IBOutlet UITextView *joke;

@end

@implementation TJKCenterViewController

#pragma View Controller Methods

// actions to perform once view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup instance to common routines
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    
    // setup the screen fonts, sizes, layout
    [self setupScreenLayout:common];
    
    // initialize property values
    self.leftButton = 1;
    
    // set background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:MAIN_VIEW_BACKGROUND]];
   
    // retrieve the latest joke
    [self retrieveLatestJoke];
}

#pragma Methods

// setup fonts, sizes, colors
-(void)setupScreenLayout:(TJKCommonRoutines *)common
{
    [self.jokeTitle setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeTitle setTextColor:[common textColor]];
    self.jokeTitle.textAlignment = NSTextAlignmentCenter;
    [self.jokeCategory setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeCategory setTextColor:[common textColor]];
    [self.jokeSubmitted setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeSubmitted setTextColor:[common textColor]];
    [self.joke setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.joke setTextColor:[common textColor]];
    [common setBorderForTextView:self.joke];
}

-(void)retrieveLatestJoke
{
    // get the search date
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    NSDate *searchDate = [common searchDateForQuery];
   
    // get the most recent joke added to the database
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateJokes = [NSPredicate predicateWithFormat:[JOKE_CREATED stringByAppendingString:@" <= %@"], searchDate];
    CKQuery *queryJokes = [[CKQuery alloc] initWithRecordType:JOKE_RECORD_TYPE predicate:predicateJokes];
    NSSortDescriptor *sortJokes = [[NSSortDescriptor alloc] initWithKey:JOKE_CREATED ascending:NO];
    queryJokes.sortDescriptors = [NSArray arrayWithObjects:sortJokes, nil];

    // return only one result from the jokes record
    CKQueryOperation *queryJokesOp = [[CKQueryOperation alloc] initWithQuery:queryJokes];
    queryJokesOp.resultsLimit = 1;
    queryJokesOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError * error)
    {
        if (error)
        {
            // display alert message and pop the view controller from the stack
            GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
            [alert displayErrorMessage:@"Oops!" errorMessage:@"The joke failed to load. Check your network, wifi, and iCloud settings and try again."];
        }
    };
    [jokePublicDatabase addOperation:queryJokesOp];
    
    // now fetch the joke record and its associated category record and display them
    queryJokesOp.recordFetchedBlock = ^(CKRecord *jokeRecord)
    {
        // get the category that belongs to the joke
        if (jokeRecord)
        {
            // get the category associated with the joke
            CKReference *referenceToCategory = jokeRecord[CATEGORY_FIELD_NAME];
            CKRecordID *categoryRecordID = referenceToCategory.recordID;
            [jokePublicDatabase fetchRecordWithID:categoryRecordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error)
             {
                 if (!error)
                 {
                     // get the latest joke
                     if (record)
                     {
                         self.latestJoke = [[TJKJokeItem alloc] init];
                         self.latestJoke = [self.latestJoke initWithJokeDescr:[jokeRecord objectForKey:JOKE_DESCR] jokeCategory:[record objectForKey:CATEGORY_FIELD_NAME] nameSubmitted:[jokeRecord objectForKey:JOKE_SUBMITTED_BY] jokeTitle:[jokeRecord objectForKey:JOKE_TITLE] categoryRecordName:nil jokeCreated:[jokeRecord valueForKey:JOKE_CREATED] jokeRecordName:jokeRecord.recordID.recordName];
                         
                         // display the latest joke
                         [self displayLatestJoke];
                     }
                     else
                     {
                         // display alert message and pop the view controller from the stack
                         GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                         [alert displayErrorMessage:@"Oops!" errorMessage:@"The joke failed to load. Check your network, wifi, and iCloud settings and try again."];
                     }
                 }
                 else
                 {
                     NSLog(@"%@",error);
                     // display alert message and pop the view controller from the stack
                     GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                     [alert displayErrorMessage:@"Oops!" errorMessage:@"The joke failed to load. Check your network, wifi, and iCloud settings and try again."];
                 }
             }];
        }
    };
}

// display the latest joke
-(void)displayLatestJoke
{
    // get the current date
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    NSString *theDate = [common getCurrentDate];
    NSString *jokeTitleString = [@"Today's Joke for " stringByAppendingString:theDate];

    if (self.latestJoke)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            // determine if joke submitted by is empty
            NSString *submittedBy = @"";
            BOOL isNameSubmitted = (self.latestJoke.nameSubmitted == nil) ? NO : YES;
            
            // if the joke submitted by is YES then check for empty spaces, if empty then set flag to NO
            if (isNameSubmitted)
            {
                submittedBy = [self.latestJoke.nameSubmitted stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                isNameSubmitted = ([submittedBy isEqualToString:@""]) ? NO : YES;
            }
            
            // display the current date
            self.jokeTitle.text = jokeTitleString;
        
            // display the category
            self.jokeCategory.text = [@"Category: " stringByAppendingString:self.latestJoke.jokeCategory];
            
            // display submitted by
            if (isNameSubmitted)
            {
                self.jokeSubmitted.text = [@"Submitted by: " stringByAppendingString:submittedBy];
            }
            else
            {
                self.jokeSubmitted.text = @"Submitted by: Anonymous";
            }

            // display the joke
            self.joke.text = self.latestJoke.jokeDescr;
        });
    }
}


#pragma Action Methods
- (void)btnMovePanelRight:(id)sender
{
    switch (self.leftButton)
    {
        case 0:
        {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1:
        {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

@end
