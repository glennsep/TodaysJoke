//
//  GHSNoSwearing.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/28/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHSNoSwearing : NSObject

#pragma properties
@property (nonatomic, readonly) NSArray *swearWords;

#pragma methods
-(NSString *)checkForSwearing:(NSString*) textToCheck numberOfWordsReturned: (NSInteger)words;

@end
