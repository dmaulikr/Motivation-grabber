//
//  Parser.h
//  Motivator grabber
//
//  Created by Влад Мазур on 18.10.13.
//  Copyright (c) 2013 Vladislav Mazur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h"

@interface Parser : NSObject

@property (strong, nonatomic) NSString * page;
@property (strong, nonatomic) HTMLParser * parser;
@property (strong, nonatomic) NSArray * interestedItems;

-(NSString *) loadPageWithURLFromString:(NSString *)stringURL;
-(NSString *) loadPageWithLocalFile:(NSString *)fileName;

-(NSArray *) findImagesURLs;
-(void) downloadPictures;
@end
