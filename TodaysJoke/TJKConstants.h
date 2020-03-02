//
//  TJKConstants.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/24/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

// declare constants
// custom container
extern NSString *const JOKE_CONTAINER;

// used when selecting categories
extern NSString *const DEFAULT_CATEGORY;
extern NSString *const LOADING_CATEGORY;

// category record types and fields
extern NSString *const CATEGORY_RECORD_TYPE;
extern NSString *const CATEGORY_FIELD_NAME;
extern NSString *const CATEGORY_FIELD_IMAGE;
extern NSString *const CATEGORY_FIELD_FAVORITE;
extern NSString *const CATEGORY_TO_REMOVE_OTHER;
extern NSString *const CATEGORY_TO_REMOVE_RANDOM;
extern NSString *const CATEGORY_TO_REMOVE_FAVORITE;
extern NSString *const CATEGORY_RECORD_NAME;
extern NSString *const CATEGORY_ALL;
extern NSString *const CATEGORY_NONE;

// joke record types and fields
extern NSString *const JOKE_RECORD_TYPE;
extern NSString *const JOKE_DESCR;
extern NSString *const JOKE_SUBMITTED_BY;
extern NSString *const JOKE_TITLE;
extern NSString *const JOKE_CREATED;
extern NSString *const JOKE_CATEGORY;
extern NSString *const JOKE_ID;
extern NSString *const JOKE_NAME_SUBMITTED;
extern NSString *const JOKE_DATE;
extern NSString *const JOKE_CREATED_SYSTEM;
extern NSString *const NO_JOKES_FOUND;

// generic parameters
extern NSString *const PARAMETERS_RECORD_TYPE;
extern NSString *const PARAMETERS_CATEGORY_RECORD_NAME;
extern NSString *const PARAMETERS_JOKE_SUBMITTED_EMAIL;
extern NSString *const PARAMETERS_CONTACT_US_EMAIL;

// fonts
extern NSString *const FONT_NAME_HEADER;
extern CGFloat   const FONT_SIZE_HEADER;
extern NSString *const FONT_NAME_LABEL;
extern CGFloat   const FONT_SIZE_LABEL;
extern NSString *const FONT_NAME_TEXT;
extern CGFloat   const FONT_SIZE_TEXT;
extern NSString *const FONT_CATEGORY_TEXT;
extern CGFloat   const FONT_CATEGORY_SIZE;
extern CGFloat   const FONT_CATEGORY_DISPLAY_SIZE;
extern NSString *const FONT_JOKE_LIST_TEXT;
extern CGFloat   const FONT_JOKE_LIST_SIZE;

// cache list names
extern NSString *const CACHE_CATEGORY_LIST;
extern NSString *const CACHE_CATEGORY_PICKER;

// file name to store favorite jokes
extern NSString *const FILE_NAME_FAVORITES;

// styles
extern NSString *const MAIN_VIEW_BACKGROUND;
extern NSString *const JOKE_CELL_BACKGROUND;
extern NSString *const RIGHT_ARROW;
extern NSString *const LEFT_ARROW;

// display constants
extern CGFloat  const SCREEN_DIM;
extern CGFloat  const REDUCE_BRIGHTNESS_FACTOR;