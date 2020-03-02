//
//  TJKJokeGallery.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKJokeGallery.h"
#import "TJKCommonRoutines.h"
#import "TJKConstants.h"

@interface TJKJokeGallery()

@property (weak, nonatomic) IBOutlet UITextView *jokeText;
@property (weak, nonatomic) IBOutlet UILabel *jokeCateogry;

@end

@implementation TJKJokeGallery

#pragma Initializers

// initialize the cell for the collection view
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {       
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TJKJokeGallery" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        [self setupTextView];        
    }
    
    return self;
}

#pragma Collection Cell Methods

#pragma Methods

// format the text view
-(void)setupTextView
{
    // initialize common routine
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    
    // setup border for text view
    [common setBorderForTextView:self.jokeText];
    
    
    // scroll text to the top
    [self.jokeText scrollRangeToVisible:NSMakeRange(0, 0)];
}

// populate the cell values
-(void)updateCell {

    // initialize common routine
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    
    // populate the joke description
    self.jokeText.text = self.jokeDescr;
    [self.jokeText setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
    [self.jokeText setTextColor:[common textColor]];

    // populate the joke category
    NSMutableString *categoryName = [[NSMutableString alloc] init];
    [categoryName appendString:@"["];
    [categoryName appendString:self.jokeCategoryText];
    [categoryName appendString:@"]"];
    self.jokeCateogry.text = [categoryName copy];
    [self.jokeCateogry setFont:[UIFont fontWithName:FONT_CATEGORY_TEXT size:FONT_CATEGORY_DISPLAY_SIZE]];
    [self.jokeCateogry setTextColor:[common categoryColor]];
    
    // scroll text to the top
    [self.jokeText scrollRangeToVisible:NSMakeRange(0, 0)];
}

@end
