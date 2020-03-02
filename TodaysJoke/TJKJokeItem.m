//
//  TJKJokeItem.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/16/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKAppDelegate.h"
#import "TJKJokeItem.h"
#define TITLE_LENGTH 15

@implementation TJKJokeItem

#pragma Implement Initializers

// designated initializer
-(instancetype)initWithJokeDescr:(NSString *)jokeDescr
                  jokeCategory:(NSString *)jokeCategory
                   nameSubmitted:(NSString *)nameSubmitted
                       jokeTitle:(NSString *)jokeTitle
              categoryRecordName:(NSString *)categoryRecordName
                     jokeCreated:(NSDate *)jokeCreated
                  jokeRecordName:(NSString *)jokeId
{
    // call the superclass initializer
    self = [super init];
    
    // if the superclass initalizer succeeded then assign values
    if (self)
    {
        // trim leading and trailing spaces from the joke
        jokeDescr = [jokeDescr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        self.jokeDescr = jokeDescr;
        self.jokeCategory = jokeCategory;
        self.nameSubmitted = nameSubmitted;
        self.jokeTitle = jokeTitle;
        self.categoryRecordName = categoryRecordName;
        _jokeCreated = jokeCreated;
        _jokeId = jokeId;

     }
    
    // return the newly initialized object
    return self;
}

// override init
-(instancetype)init
{
    return [self initWithJokeDescr:@"" jokeCategory:@"" nameSubmitted:@"" jokeTitle:@"" categoryRecordName:@"" jokeCreated:[NSDate date] jokeRecordName:@""];
}

// encoder initializer
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _jokeCreated = [aDecoder decodeObjectForKey:@"jokeCreated"];
        _jokeTitle = [aDecoder decodeObjectForKey:@"jokeTitle"];
        _jokeDescr = [aDecoder decodeObjectForKey:@"jokeDescr"];
        _nameSubmitted = [aDecoder decodeObjectForKey:@"nameSubmitted"];
        _jokeCategory = [aDecoder decodeObjectForKey:@"jokeCategory"];
        _categoryRecordName = [aDecoder decodeObjectForKey:@"categoryRecordName"];
        _jokeId = [aDecoder decodeObjectForKey:@"jokeId"];
    }
    return self;
}


#pragma Methods

// create a Joke Item
+(instancetype)createJoke:(NSString *)jokeDescr
          JokeCategory:(NSString *)jokeCategory
            nameSubmitted:(NSString *)nameSubmitted
                jokeTitle:(NSString *)jokeTitle
    categoryRecordName:(NSString *)categoryRecordName
              jokeCreated:(NSDate *)jokeCreated
           jokeRecordName:(NSString *)jokeId
{
    TJKJokeItem *newItem = [[self alloc] initWithJokeDescr:jokeDescr
                                             jokeCategory:jokeCategory
                                                nameSubmitted:nameSubmitted
                                                 jokeTitle:jokeTitle
                                        categoryRecordName:categoryRecordName
                                               jokeCreated:jokeCreated
                                             jokeRecordName:jokeId];
    
    // return new joke item
    return newItem;
}

// implement encoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.jokeCreated forKey:@"jokeCreated"];
    [aCoder encodeObject:self.jokeTitle forKey:@"jokeTitle"];
    [aCoder encodeObject:self.jokeDescr forKey:@"jokeDescr"];
    [aCoder encodeObject:self.nameSubmitted forKey:@"nameSubmitted"];
    [aCoder encodeObject:self.jokeCategory forKey:@"jokeCategory"];
    [aCoder encodeObject:self.categoryRecordName forKey:@"categoryRecordName"];
    [aCoder encodeObject:self.jokeId forKey:@"jokeId"];
}

@end
