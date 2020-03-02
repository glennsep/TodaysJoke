//
//  TJKJokeItemStore.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TJKJokeItem;

@interface TJKJokeItemStore : NSObject

#pragma Properties
@property(nonatomic, readonly, copy) NSArray *allItems;
@property(nonatomic,readonly,copy) TJKJokeItem *lastItem;

#pragma Singleton
+(instancetype)sharedStore;

#pragma Methods

// create a new joke item
-(TJKJokeItem *)createItem:(NSString *)jokeDescr
              jokeCategory:(NSString *)jokeCategory
             nameSubmitted:(NSString *)nameSubmitted
                 jokeTitle:(NSString *)jokeTitle
        categoryRecordName:(NSString *)categoryRecordName
               jokeCreated:(NSDate *)jokeCreated
            jokeRecordName:(NSString *)jokeId;

// remove a joke item from the array
-(void)removeItem:(TJKJokeItem *)jokeItem;

// remove all joke items
-(void)removeAllItems;

// re-arrange items in random order
-(void)randomizeItems;

// insert a joke into the favorites collection
-(void)insertFavoriteJoke:(TJKJokeItem *)jokeItem;

// remove a joke from the favorites collection
-(void)removeFavoriteJoke:(TJKJokeItem *)jokeItem;

// save the favorite jokes to archive
-(void)saveFavoritesToArchive;

// retrieve all favorite jokes from archive
-(void)retrieveFavoritesFromArchive;

// retrieve favorite jokes from array
-(NSArray *) retrieveFavoritesFromStore;

// check if joke is in favorite collection
-(int)checkIfFavorite:(TJKJokeItem *)jokeItem;

@end
