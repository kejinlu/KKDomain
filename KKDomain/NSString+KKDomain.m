//
//  NSString+KKDomain.m
//  KKDomain
//
//  Created by Luke on 4/6/14.
//  Copyright (c) 2014 geeklu. All rights reserved.
//

#import "NSString+KKDomain.h"

@implementation NSString (KKDomain)

- (NSDictionary *)rulesTree{
    static NSDictionary *rules = nil;
    if (!rules) {
        for (NSBundle *bundle in [NSBundle allBundles]) {
            NSString *rulePath = [bundle pathForResource:@"etld" ofType:@"plist"];
            if (rulePath) {
                rules = [NSDictionary dictionaryWithContentsOfFile:rulePath];
                break;
            }
        }
    }
    return rules;
}

- (NSString *)searchForHostComponents:(NSMutableArray *)components inNode:(NSDictionary *)node{
    if (node[@"!"]) {
        return @"";
    }
    
    if ([components count] == 0) {
        return nil;
    }
    
    NSString *lastComponent = [[components lastObject] lowercaseString];
    [components removeLastObject];
    
    NSString *result = nil;
    
    if (node[lastComponent]) {
        result = [self searchForHostComponents:components inNode:node[lastComponent]];
    } else if (node[@"*"]) {
        result = [self searchForHostComponents:components inNode:node[@"*"]];
    } else {
        return lastComponent;
    }
    
    if (result) {
        if ([result isEqualToString:@""]) {
            return lastComponent;
        } else {
            return [NSString stringWithFormat:@"%@.%@",result,lastComponent];
        }
    } else {
        return nil;
    }
}


- (NSString *)registeredDomain{
    if ([self hasPrefix:@"."] || [self hasSuffix:@"."]) {
        return nil;
    }
    
    NSMutableArray *hostComponents = [[self componentsSeparatedByString:@"."] mutableCopy];
    if ([hostComponents count] <= 1) {
        return nil;
    }
    
    NSString *topLevelDomain = [self searchForHostComponents:hostComponents inNode:[self rulesTree]];
    return topLevelDomain;
}


@end
