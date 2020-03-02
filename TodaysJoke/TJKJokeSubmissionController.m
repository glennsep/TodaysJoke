//
//  TJKJokeSubmission.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/11/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKJokeSubmissionController.h"
#import "TJKCommonRoutines.h"
#import "TJKAppDelegate.h"
#import "TJKConstants.h"

@interface TJKJokeSubmissionController ()
@property (weak, nonatomic) IBOutlet UITextView *jokeHelp;

@end

@implementation TJKJokeSubmissionController

#pragma Initializers

// override the UIViewController's designated initializer to prevent its use, we want to
// use initForNewItem instead
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
   
    // setup navigation bar
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.navigationController.navigationBar.tintColor = [common NavigationBarColor];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"JokeHelp.png"];
    
    // set background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:MAIN_VIEW_BACKGROUND]];
    
    // set the ui text view delegate
    self.jokeHelp.delegate = self;
    
    // set the auto adjust scroll bars to NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // dislay the help text
    [self displayJokeHelpText:common];
}

// logic to run when view appears
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // scroll text to the top
    [self.jokeHelp scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITextView Methods

// prevents editing and keyboard from showing
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

#pragma Methods

// display the joke submission text
-(void)displayJokeHelpText:(TJKCommonRoutines *)common
{
    // populate the text field
    self.jokeHelp.text = @"\nThank you for submitting a joke!\n\n";
    self.jokeHelp.text = [self.jokeHelp.text stringByAppendingString:@"\u2022 All jokes submitted are sent for approval and will not be automatically included in the joke database.\n\n"];
    self.jokeHelp.text = [self.jokeHelp.text stringByAppendingString:@"\u2022 Your e-mail address will never be stored or given out.\n\n"];
    self.jokeHelp.text = [self.jokeHelp.text stringByAppendingString:@"\u2022 Please select a joke category. Select \"Other\" if your joke doesn't fit into an existing category.\n\n"];
    self.jokeHelp.text = [self.jokeHelp.text stringByAppendingString:@"\u2022 In the “Submitted by” field you can enter your name if you want recognition.  It is suggested you just enter your first name.  You can even create your own user name.  This field is optional.  Your name will never be stored or given out.\n\n"];
    self.jokeHelp.text = [self.jokeHelp.text stringByAppendingString:@"\u2022 In the field called \"Joke\" try and avoid profanity and hate jokes.\n\n"];
    self.jokeHelp.text = [self.jokeHelp.text stringByAppendingString:@"\u2022 When submitting a joke, the system may warn you if you add profanity, but this will not automatically have your joke rejected.\n\n"];
    self.jokeHelp.text = [self.jokeHelp.text stringByAppendingString:@"\u2022 If your joke is approved and you clicked on \"Notify Me\" we will let you know what day your joke will appear.\n\n"];
    
    // set the help text font, size, and color
    [self.jokeHelp setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
    [self.jokeHelp setTextColor:[common textColor]];
    
    // set up the text box border
    [common setBorderForTextView:self.jokeHelp];
}

@end
