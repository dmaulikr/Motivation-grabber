//
//  Parser.m
//  Motivator grabber
//
//  Created by Влад Мазур on 18.10.13.
//  Copyright (c) 2013 Vladislav Mazur. All rights reserved.
//

#import "Parser.h"
#import "HTMLNode.h"

@implementation Parser

@synthesize page = _page;

-(NSString *)page
{
    if(_page == nil)
        _page = @"Empty yet";
    return _page;
}

-(NSString *) loadPageWithURLFromString:(NSString *)stringURL
{
    NSError * error = nil;
    NSURL * url = [NSURL URLWithString:stringURL];
    NSString * result = [NSString stringWithContentsOfURL:url
                                                 encoding:NSUTF8StringEncoding error:&error];
    if (nil == result)
        NSLog(@"Error (loadPageWithURLFromString):%@", error.description);
    
    self.page = result;
    return result;
}

-(NSString *) loadPageWithLocalFile:(NSString *)fileName
{
    NSString * result;
    NSError * error = nil;
    
    result = [NSString stringWithContentsOfFile:fileName
                                       encoding:NSUTF8StringEncoding error:&error];
    if (nil == result)
        NSLog(@"Error (loadPageWithLocalFile):%@", error.description);
    
    self.page = result;
    return result;
}

-(NSArray *) findImagesURLs
{
    if ([self.page isEqualToString:@"Empty yet"]) {
        NSLog(@"Error (lookForItemWithID): page is empty");
        return nil;
    }
    NSError * error = nil;
    self.parser = [[HTMLParser alloc] initWithString:self.page error:&error];
    
    HTMLNode * body = [self.parser body];
    NSArray * posts = [body findChildTags:@"img"];
    NSMutableArray * urls = [[NSMutableArray alloc] initWithCapacity:100];
    for (HTMLNode * node in posts) {
        [urls addObject: [@"http://motivate.polivanov.me" stringByAppendingString:[[node parent] getAttributeNamed:@"href"]]];
    }
    
    self.interestedItems = [urls copy];
    return [urls copy];
}

-(void) downloadFileFromURL:(NSString *)fileURL
{
    NSString * fileName = [[fileURL componentsSeparatedByString:@"/"] lastObject];
    NSString * directory = @"/Users/vladmazur/Downloads/Motivate/";
    
    NSURL  *url = [NSURL URLWithString:fileURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", directory, fileName];
        [urlData writeToFile:filePath atomically:YES];
    }
    NSLog(@"%@ OK", fileName);
}

-(void) downloadPictures
{
    [self loadPageWithLocalFile:@"/Users/vladmazur/Downloads/motivate.html"];
    [self findImagesURLs];
    
    uint index = 1, count = (uint) [self.interestedItems count];
    for (NSString * url in self.interestedItems)
    {
        Parser * parser = [[Parser alloc] init];
        [parser loadPageWithURLFromString:url];
        NSError * error = nil;
        parser.parser = [[HTMLParser alloc] initWithString:parser.page error:&error];
        HTMLNode * node = [[parser.parser body] findChildWithAttribute:@"data-title" matchingName:@"Предполагается печать на формате А4" allowPartial:YES];
        NSString * imageURL = [node getAttributeNamed:@"href"];
        [self downloadFileFromURL:imageURL];
        NSLog(@"%i of %i", index++, count);
    }
}

@end
