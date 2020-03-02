//
//  TJKJokeItem.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/16/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJKJokeItem : NSObject <NSCoding>

#pragma Declare Properties

@property (nonatomic, readonly, strong) NSDate *jokeCreated;
@property (nonatomic, copy) NSString *jokeTitle;
@property (nonatomic, copy) NSString *jokeDescr;
@property (nonatomic, copy) NSString *nameSubmitted;
@property (nonatomic, copy) NSString *jokeCategory;
@property (nonatomic, copy) NSString *categoryRecordName;
@property (nonatomic, readonly, strong) NSString *jokeId;

#pragma Declare Initializers

// designated initializer
-(instancetype)initWithJokeDescr:(NSString *)jokeDescr
                  jokeCategory:(NSString *)jokeCategory
                   nameSubmitted:(NSString *)nameSubmitted
                       jokeTitle:(NSString*)jokeTitle
              categoryRecordName:(NSString *)categoryRecordName
                     jokeCreated:(NSDate*)jokeCreated
                  jokeRecordName:(NSString *)jokeIdTJKJokeItem;


// create a joke item
+(instancetype)createJoke:(NSString *)jokeDescr
           JokeCategory:(NSString *)jokeCategory
            nameSubmitted:(NSString *)nameSubmitted
                jokeTitle:(NSString *)jokeTitle
       categoryRecordName:(NSString *)categoryRecordName
              jokeCreated:(NSDate *)jokeCreated
           jokeRecordName:(NSString *)jokeId;

@end
