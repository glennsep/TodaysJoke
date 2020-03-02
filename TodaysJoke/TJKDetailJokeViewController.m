//
//  TJKDetailJokeViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TJKDetailJokeViewController.h"
#import "TJKJokeSubmissionController.h"
#import "GHSNoSwearing.h"
#import "GHSAlerts.h"
#import "TJKAppDelegate.h"
#import "TJKConstants.h"
#import "TJKCommonRoutines.h"

// define constants
#define MAX_NUMBER_OF_BAD_WORDS 5
#define MOVE_SCREEN_Y_AXIS_TEXT 125
#define MOVE_SCREEN_Y_AXIS_VIEW 186

@interface TJKDetailJokeViewController ()

#pragma Outlets
@property (weak, nonatomic) IBOutlet UILabel *jokeCategoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *jokeCategory;
@property (weak, nonatomic) IBOutlet UILabel *jokeSubmittedByLabel;
@property (weak, nonatomic) IBOutlet UITextField *jokeSubmittedBy;
@property (weak, nonatomic) IBOutlet UILabel *notifyMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jokeLabel;
@property (weak, nonatomic) IBOutlet UITextView *joke;
@property (strong, nonatomic) IBOutlet UIView *jokeDetailView;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *notifyMe;

#pragma Properties
@property (strong, nonatomic) UIPickerView *jokeCategoryPicker;
@property (strong, nonatomic) UIToolbar * jokeCategoryPickerToolbar;
@property (nonatomic, strong) NSArray *jokeCategories;
@property (nonatomic) BOOL notifyMeCheckedSelected;

@end

@implementation TJKDetailJokeViewController

#pragma Initializers

// create buttons in the navgigation bar
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    // if initiated then create button items
    if (self)
    {
        // create button to submit an e-mail
        UIBarButtonItem *submitItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                       target:self
                                       action:@selector(submitJoke:)];
        self.navigationItem.rightBarButtonItem = submitItem;        
    }
    
    return self;
}

#pragma View Controller Methods

// implement actions when the view is loaded
-(void)viewDidLoad
{
    // call super method
    [super viewDidLoad];
    
    // setup scren title
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"SubmitJoke.png"];
    self.navigationController.navigationBar.tintColor = [common NavigationBarColor];
    
    // set background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:MAIN_VIEW_BACKGROUND]];
    
    // initialize notify me check box to unselected
    self.notifyMeCheckedSelected = NO;
    
    // setup notify me check box
    [self setupNotifyMeCheckBox];
    
    // assign delegate of uitextfield
    self.jokeSubmittedBy.delegate = self;
    
    // set screen fonts, sizes, colors
    [self setupScreenLayout:common];
    
    // disable joke category selector
    _jokeCategory.enabled = NO;
    
    // indicate categories are loading
    _jokeCategory.text = LOADING_CATEGORY;
    
    // setup image for text field
    _jokeCategory.rightViewMode = UITextFieldViewModeAlways;
    _jokeCategory.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downarrow.png"]];
    
    
    // set the image for help button
    UIImage *questionButton = [UIImage imageNamed:@"helpButton.png"];
    [self.helpButton setBackgroundImage:questionButton forState:UIControlStateNormal];
    [self.helpButton setShowsTouchWhenHighlighted:NO];
    
    // round corners of help button
    self.helpButton.layer.cornerRadius = 5;
    self.helpButton.clipsToBounds = YES;
    
    // retrieve joke categories for picker
    [self retreiveCategoriesForPicker];
    
    // set up the picker for the joke categories
    self.jokeCategoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width,self.view.frame.size.height / 4)];
    
    self.jokeCategoryPicker.delegate = self;
    self.jokeCategoryPicker.dataSource = self;
    [self.jokeCategoryPicker setShowsSelectionIndicator:YES];
    self.jokeCategory.inputView = _jokeCategoryPicker;
    
    // setup done button in picker
    self.jokeCategoryPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,56)];
    self.jokeCategoryPickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.jokeCategoryPickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:self
                                  action:nil];


    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self
                                action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [self.jokeCategoryPickerToolbar setItems:barItems animated:YES];
    self.jokeCategory.inputAccessoryView = self.jokeCategoryPickerToolbar;
}

#pragma Methods

// setup screen font, sizes, and colors
-(void)setupScreenLayout:(TJKCommonRoutines *)common
{
    // joke category label
    [self.jokeCategoryLabel setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeCategoryLabel setTextColor:[common labelColor]];
    
    // joke category text
    [self.jokeCategory setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
    [self.jokeCategory setTextColor:[common textColor]];
    
    // submitted by label
    [self.jokeSubmittedByLabel setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeSubmittedByLabel setTextColor:[common labelColor]];
    
    // submitted by text
    [self.jokeSubmittedBy setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
    [self.jokeSubmittedBy setTextColor:[common textColor]];
    
    // notify me label
    [self.notifyMeLabel setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.notifyMeLabel setTextColor:[common labelColor]];
    
    // joke label
    [self.jokeLabel setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeLabel setTextColor:[common labelColor]];
    
    // joke text
    [self.joke setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
    [self.joke setTextColor:[common textColor]];    
    
    // setup border for text view (used to type in joke)
    [common setBorderForTextView:self.joke];
}

// retrieve categories for picker
-(void)retreiveCategoriesForPicker
{
    // check if categories are cached
    if ([self.cacheLists objectForKey:CACHE_CATEGORY_PICKER])
    {
        // retrieve categories from cache and set initial joke category
        _jokeCategories = [self.cacheLists objectForKey:CACHE_CATEGORY_PICKER];
        _jokeCategory.text = DEFAULT_CATEGORY;
        _jokeCategory.enabled = YES;
    }
    else
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
                 [self.cacheLists setObject:_jokeCategories forKey:CACHE_CATEGORY_PICKER];
                 
                 // set initial value for joke category
                 dispatch_async(dispatch_get_main_queue(), ^{
                     _jokeCategory.text = DEFAULT_CATEGORY;
                     _jokeCategory.enabled = YES;
                 });
                 
             }
             else
             {
                 // display error message
                 GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                 errorActionBlock errorBlock = ^void(UIAlertAction *action) {[self cancelJoke:self];};
                 [alert displayErrorMessage:@"Oops!" errorMessage:@"We had trouble reading in the joke categories. Check your network, wifi, and iCloud settings and try again." errorAction:errorBlock];
             }
         }];
    }
}

// setup notify me check box
-(void)setupNotifyMeCheckBox
{
    // setup check box images
    [self.notifyMe setBackgroundImage:[UIImage imageNamed:@"Checkbox-unchecked.png"]
                        forState:UIControlStateNormal];
    [self.notifyMe setBackgroundImage:[UIImage imageNamed:@"Checkbox-checked.png"]
                        forState:UIControlStateSelected];
    [self.notifyMe setBackgroundImage:[UIImage imageNamed:@"Checkbox-checked.png"]
                        forState:UIControlStateHighlighted];
    
    // setup check box to respond when clicked
    [self.notifyMe addTarget:self action:@selector(notifyMeChecked:) forControlEvents:UIControlEventTouchUpInside];
    self.notifyMe.adjustsImageWhenHighlighted=YES;
}

// check or uncheck notify me box
-(void)notifyMeChecked:(id)sender
{
    // toggle check box
    self.notifyMeCheckedSelected = !self.notifyMeCheckedSelected;
    [self.notifyMe setSelected:self.notifyMeCheckedSelected];
}

// action to take when done button is pressed on picker toolbar
-(void)pickerDoneClicked
{
    [self.jokeCategory resignFirstResponder];
}

// submit the joke via e-mail
-(void)submitJoke:(id)sender
{
    // instantiate the alert object
    GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
    
    // check if the device can send mail
    if (![MFMailComposeViewController canSendMail])
    {
        [alerts displayErrorMessage:@"Invalid Submission" errorMessage:@"This device cannot send e-mail."];
        return;
    }
    
    // validate the fields
    NSArray *isValid = [NSArray arrayWithArray:self.validateSubmittedJoke];
    if ([isValid count] > 0)
    {
        // display the issues to the user
        NSString *errorMessage = [isValid componentsJoinedByString:@"\r\r"];
        [alerts displayErrorMessage:@"Invalid Submission" errorMessage:errorMessage];
        return;
    }

    // check for swear words
    NSMutableString *combineBadWords = [[NSMutableString alloc] init];
    [combineBadWords appendString:self.jokeSubmittedBy.text];
    [combineBadWords appendString:@" "];
    [combineBadWords appendString:self.joke.text];
    NSString *checkBadWords = [combineBadWords copy];
        
    GHSNoSwearing *foundBadWords = [[GHSNoSwearing alloc] init];
    NSString *badWords = [foundBadWords checkForSwearing:checkBadWords numberOfWordsReturned:MAX_NUMBER_OF_BAD_WORDS];
    
    // if bad words are found then display them and warn the user the joke might not be accepted, but e-mail the joke anyway
    if (![badWords isEqual: @"OK"])
    {
        NSString *badWordsMessage = [@"You can submit your joke, but it might not be accepted due to the following word(s) found:\r\r" stringByAppendingString:badWords];
        errorActionBlock errorBlock = ^void(UIAlertAction *action) {[self sendJokeViaEmail];};
        [alerts displayErrorMessage:@"Possible Problem" errorMessage:badWordsMessage errorAction:errorBlock];
    }
    else
    {
        [self sendJokeViaEmail];
    }
}

// send the e-mail
-(void)sendJokeViaEmail
{
    // get the e-mail address from the data source
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    CKRecordID *parameterRecordID = [[CKRecordID alloc] initWithRecordName:PARAMETERS_CATEGORY_RECORD_NAME];
    [jokePublicDatabase fetchRecordWithID:parameterRecordID completionHandler:^(CKRecord *parameterRecord, NSError *error)
    {
        if (!error)
        {
            // setup the string for the message body
            NSString *jokeSubmitted = self.jokeSubmittedBy.text;
            jokeSubmitted = [jokeSubmitted stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            jokeSubmitted = [jokeSubmitted length] == 0 ? jokeSubmitted = @"N/A" : jokeSubmitted;
            NSString *jokeCategory = self.jokeCategory.text;
            NSString *notifyMe = (self.notifyMeCheckedSelected ? @"Yes" : @"No");
            NSString *joke = self.joke.text;
            NSString *messageBody = [NSString stringWithFormat:@"%@%@\n\n%@%@\n\n%@%@\n\n%@\n%@",
                                     @"Joke Submitted By: ", jokeSubmitted,
                                     @"Notify Me: ", notifyMe,
                                     @"Joke Category: ", jokeCategory,
                                     @"Joke:", joke];

            // setup recipients
            NSString *jokeSubmittedBy = [parameterRecord objectForKey:PARAMETERS_JOKE_SUBMITTED_EMAIL];
            NSArray *toRecipents = [NSArray arrayWithObject:jokeSubmittedBy];

            // prepare the mail message
            mailComposer = [[MFMailComposeViewController alloc] init];
            mailComposer.mailComposeDelegate = self;
            [mailComposer setSubject:@"Joke Submission"];
            [mailComposer setMessageBody:messageBody isHTML:NO];
            [mailComposer setToRecipients:toRecipents];

            // present mail on the screen
            [self presentViewController:mailComposer animated:YES completion:nil];
        }
        else
        {
            // display error message
            dispatch_async(dispatch_get_main_queue(), ^{
                GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                [alert displayErrorMessage:@"Problem" errorMessage:@"Could not obtain recipient e-mail address. Check your network, wifi, and iCloud settings and try again."];
            });
        }
    }];
}

// cancel the adding of a new joke
-(void)cancelJoke:(id)sender
{
    // since the user cancelled remove the joke from the store
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

// indicate the number of items that can be selected in picker view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// indicate the number of rows in the picker view
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _jokeCategories.count;
}

// return selected item in picker view
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _jokeCategories[row];
}

// display the selected item in the picker view in the text field
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _jokeCategory.text = _jokeCategories[row];
}

// move screen up when editing starts
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag > 1)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -MOVE_SCREEN_Y_AXIS_TEXT, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

// move screen down when editing ends
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag > 1)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +MOVE_SCREEN_Y_AXIS_TEXT, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

// move screen up when editing begins in joke field
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 3)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -MOVE_SCREEN_Y_AXIS_VIEW, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

// move screen down when editing ends in joke field
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 3)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +MOVE_SCREEN_Y_AXIS_VIEW, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

// remove keyboard when return key is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// validate the entered text
-(NSArray *)validateSubmittedJoke
{
    // declare an array
    NSMutableArray *valid = [[NSMutableArray alloc] init];
    
    // check if the joke category is not empty as it not set to "NONE"
    if (![self.jokeCategory hasText] || [self.jokeCategory.text  isEqual: DEFAULT_CATEGORY])
    {
        // if empty or none indicae this in the array
        NSString *defaultCategory = [DEFAULT_CATEGORY stringByAppendingString:@"\""];
        NSString *invalidCategory = [@"The Joke Category must contain a value and cannot be \"" stringByAppendingString:defaultCategory];
        [valid addObject:invalidCategory];
    }
    
    // check if a joke was entered
    if (![self.joke hasText])
    {
        // if empty indicate there must be a joke present
        [valid addObject:@"You must enter a Joke!"];
    }
    
    return [valid copy];
}

// actions to perform when message sent via e-mail
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma Actions

// dismis keyboard if background is selected
- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

// display a screen to help with joke submission
- (IBAction)displayJokeHelp:(id)sender
{
    // create an instance of the joke submission help screen
    TJKJokeSubmissionController *jokeSubmissionController = [[TJKJokeSubmissionController alloc] initWithNibName:nil bundle:nil];
    
    // display the help screen
    [self.navigationController pushViewController:jokeSubmissionController animated:YES];
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:jokeSubmissionController];
//    [self presentViewController:navController animated:YES completion:NULL];
}


@end
