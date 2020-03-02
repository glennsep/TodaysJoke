//
//  GHSNoSwearing.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/28/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "GHSNoSwearing.h"

@implementation GHSNoSwearing

#pragma initializer

// override the default initializer
-(instancetype)init
{
    // call the super class initializer
    [self superclass];
    
    // initialize the array with the curse words
    _swearWords = @[@"anus", @"arse", @"arsehole", @"ass", @"ass-hat", @"ass-jabber", @"ass-pirate",@"assbag", @"assbandit", @"assbanger", @"assbite", @"assclown", @"asscock",
                    @"asscracker", @"asses", @"assface", @"assfuck", @"assfucker", @"assgoblin", @"asshat", @"asshead", @"asshole", @"asshopper", @"assjacker", @"asslick",
                    @"asslicker", @"assmonkey", @"assmunch", @"assmuncher", @"assnigger", @"asspirate", @"assshit", @"assshole", @"asssucker", @"asswad", @"asswipe", @"axwound",
                    @"bampot", @"bastard", @"beaner", @"bitch", @"bitchass", @"bitches", @"bitchtits", @"bitchy", @"blow job", @"blowjob", @"bollocks", @"bollox", @"boner",
                    @"brotherfucker", @"bullshit", @"bumblefuck", @"butt plug", @"butt-pirate", @"buttfucka", @"buttfucker", @"camel toe", @"carpetmuncher", @"chesticle",
                    @"chinc", @"chink", @"choad", @"chode", @"clit", @"clitface", @"clitfuck", @"clusterfuck", @"cock", @"cockass", @"cockbite", @"cockburger", @"cockface",
                    @"cockfucker", @"cockhead", @"cockjockey", @"cockknoker", @"cockmaster", @"cockmongler", @"cockmongruel", @"cockmonkey", @"cockmuncher", @"cocknose",
                    @"cocknugget", @"cockshit", @"cocksmith", @"cocksmoke", @"cocksmoker", @"cocksniffer", @"cocksucker", @"cockwaffle", @"coochie", @"coochy", @"coon",
                    @"cooter", @"cracker", @"cum", @"cumbubble", @"cumdumpster", @"cumguzzler", @"cumjockey", @"cumslut", @"cumtart", @"cunnie", @"cunnilingus", @"cunt",
                    @"cuntass", @"cuntface", @"cunthole", @"cuntlicker", @"cuntrag", @"cuntslut", @"dago", @"damn", @"deggo", @"dick", @"dick-sneeze", @"dickbag", @"dickbeaters",
                    @"dickface", @"dickfuck", @"dickfucker", @"dickhead", @"dickhole", @"dickjuice", @"dickmilk", @"dickmonger", @"dicks", @"dickslap", @"dicksucker", @"dicksucking",
                    @"dicktickler", @"dickwad", @"dickweasel", @"dickweed", @"dickwod", @"dike", @"dildo", @"dipshit", @"doochbag", @"dookie", @"douche", @"douche-fag", @"douchebag",
                    @"douchewaffle", @"dumass", @"dumb ass", @"dumbass", @"dumbfuck", @"dumbshit", @"dumshit", @"dyke", @"fag", @"fagbag", @"fagfucker", @"faggit", @"faggot", @"faggotcock",
                    @"fagtard", @"fatass", @"fellatio", @"feltch", @"flamer", @"fuck", @"fuckass", @"fuckbag", @"fuckboy", @"fuckbrain", @"fuckbutt", @"fuckbutter", @"fucked", @"fucker",
                    @"fuckersucker", @"fuckface", @"fuckhead", @"fuckhole", @"fuckin", @"fucking", @"fucknut", @"fucknutt", @"fuckoff", @"fucks", @"fuckstick", @"fucktard", @"fucktart",
                    @"fuckup", @"fuckwad", @"fuckwit", @"fuckwitt", @"fudgepacker", @"gay", @"gayass", @"gaybob", @"gaydo", @"gayfuck", @"gayfuckist", @"gaylord", @"gaytard", @"gaywad",
                    @"goddamn", @"goddamnit", @"gooch", @"gook", @"gringo", @"guido", @"handjob", @"hard on", @"heeb", @"hell", @"ho", @"hoe", @"homo", @"homodumbshit", @"honkey",
                    @"humping", @"jackass", @"jagoff", @"jap", @"jerk off", @"jerkass", @"jigaboo", @"jizz", @"jungle bunny", @"junglebunny", @"kike", @"kooch", @"kootch", @"kraut",
                    @"kunt", @"kyke", @"lameass", @"lardass", @"lesbian", @"lesbo", @"lezzie", @"mcfagget", @"mick", @"minge", @"mothafucka", @"mothafuckin", @"motherfucker",
                    @"motherfucking", @"muff", @"muffdiver", @"munging", @"negro", @"nigaboo", @"nigga", @"nigger", @"niggers", @"niglet", @"nut sack", @"nutsack", @"paki", @"panooch",
                    @"pecker", @"peckerhead", @"penis", @"penisbanger", @"penisfucker", @"penispuffer", @"piss", @"pissed", @"pissed off", @"pissflaps", @"polesmoker", @"pollock",
                    @"poon", @"poonani", @"poonany", @"poontang", @"porch monkey", @"porchmonkey", @"prick", @"punanny", @"punta", @"pussies", @"pussy", @"pussylicking", @"puto",
                    @"queef", @"queer", @"queerbait", @"queerhole", @"renob", @"rimjob", @"ruski", @"sand nigger", @"sandnigger", @"schlong", @"scrote", @"shit", @"shitass",
                    @"shitbag", @"shitbagger", @"shitbrains", @"shitforbrains", @"shitbreath", @"shitcanned", @"shitcunt", @"shitdick", @"shitface", @"shitfaced", @"shithead",
                    @"shithole", @"shithouse", @"shitspitter", @"shitstain", @"shitter", @"shittiest", @"shitting", @"shitty", @"shiz", @"shiznit", @"skank", @"skeet", @"skullfuck",
                    @"slut", @"slutbag", @"smeg", @"snatch", @"spic", @"spick", @"splooge", @"spook", @"suckass", @"tard", @"testicle", @"thundercunt", @"tit", @"titfuck",
                    @"tits", @"tittyfuck", @"twat", @"twatlips", @"twats", @"twatwaffle", @"unclefucker", @"va-j-j", @"vag", @"vagina", @"vajayjay", @"vjayjay", @"wank", @"wankjob",
                    @"wetback", @"whore", @"whorebag", @"whoreface", @"wop"];

    
    // return the instance of the object
    return self;
}

#pragma Methods

// checks if a string contains any swear words.  If so it returns the words found. If no swear words found it returns "OK".
// the parameter "words" indicates how many swear words are returned.  If zero (0) then all swear words found are returned.
-(NSString *)checkForSwearing:(NSString*) textToCheck numberOfWordsReturned: (NSInteger)words
{
    // declare the string to return
    NSMutableString *swearWordsFound = [[NSMutableString alloc] init];
    
    // declare variables
    NSString *swearWord;
    NSString *stringToReturn = [[NSString alloc] init];
    NSString *formattedSwearWord = [[NSString alloc] init];
    NSInteger numberOfWordsInArray = [self.swearWords count];
    NSInteger numberOfWordsFound = 0;
    BOOL maxWords = NO;
    
    // make the text to check lower case
    textToCheck = [textToCheck lowercaseString];
    
    // loop through all words in the array
    for (NSUInteger i = 0; i < numberOfWordsInArray; i++)
    {
        // get the swear word
        swearWord = [self.swearWords objectAtIndex:i];
        
        // check if swear word found
        if ([textToCheck rangeOfString:swearWord].location != NSNotFound)
        {
            // check if max number of words found
            numberOfWordsFound++;
            if (words != 0 && numberOfWordsFound > words)
            {
                maxWords = YES;
            }
            
            if (!maxWords)
            {
            formattedSwearWord = [NSString stringWithFormat:@"\"%@\", ", swearWord];
            [swearWordsFound appendString:formattedSwearWord];
            }
            
            // break out of loop if max words found
            if (maxWords)
            {
                if (numberOfWordsFound > words)
                {
                formattedSwearWord = [NSString stringWithFormat:@"%@", @"... and others, "];
                [swearWordsFound appendString:formattedSwearWord];
                }
                break;
            }
        }
    }
    
    // if no swear words found then indicate all is well
    if ([swearWordsFound length] == 0)
    {
        [swearWordsFound appendString:@"OK"];
    }
    
    // remove the comma if necessary
    stringToReturn = [swearWordsFound copy];
    if (![stringToReturn isEqual:@"OK"])
    {
        stringToReturn = [stringToReturn substringToIndex:[stringToReturn length] - 2];
    }
    
    // return the swear words
    return stringToReturn;
}

@end
