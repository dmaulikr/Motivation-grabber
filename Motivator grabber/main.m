//
//  main.m
//  Motivator grabber
//
//  Created by Влад Мазур on 18.10.13.
//  Copyright (c) 2013 Vladislav Mazur. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Parser.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        Parser * parser = [[Parser alloc] init];
//        [parser loadPageWithLocalFile:@"/Users/vladmazur/Downloads/motivate.html"];
//        [parser findItemWithClass:@"post archive"];
        [parser downloadPictures];
    }
    return 0;
}

