//
//  main.m
//  ETLDPlistGenerator
//
//  Created by Luke on 4/6/14.
//  Copyright (c) 2014 geeklu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSStringPunycodeAdditions.h"

void buildDomain(NSMutableDictionary *node, NSMutableArray *domainParts){
    if ([domainParts count] ==0) {
        return;
    }
    
    NSString *domainPart = [domainParts lastObject];
    [domainParts removeLastObject];
    
    BOOL notDomain = NO;
    if ([domainPart hasPrefix:@"!"]) {
        notDomain = YES;
        domainPart = [domainPart substringFromIndex:1];
    }
    
    NSMutableDictionary *childNode = node[domainPart];
    if (!childNode) {
        childNode = [NSMutableDictionary dictionary];
        if (notDomain) {
            [childNode setObject:@{} forKey:@"!"];
        }
        [node setObject:childNode forKey:domainPart];
    }
    
    if (!notDomain && [domainParts count] > 0) {
        buildDomain(childNode, domainParts);
    }
}

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://publicsuffix.org/list/effective_tld_names.dat"]];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *ruleText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSArray *ruleTextLines = [ruleText componentsSeparatedByString:@"\n"];
        
        NSMutableDictionary *ruleDictionary = [NSMutableDictionary dictionary];
        for (NSString *ruleTextLine in ruleTextLines) {
            NSString *ruleLine = [ruleTextLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([ruleLine hasPrefix:@"//"] || [ruleLine length] == 0) {
                continue;
            }
            NSString *ruleLineIDNAEncoded = [ruleLine IDNAEncodedString];
            
            NSMutableArray *ruleComponents = [[ruleLine componentsSeparatedByString:@"."] mutableCopy];
            buildDomain(ruleDictionary, ruleComponents);
            
            if (![ruleLine isEqualToString:ruleLineIDNAEncoded]) {
                NSMutableArray *ruleIDNAEncodedComponents = [[ruleLineIDNAEncoded componentsSeparatedByString:@"."] mutableCopy];
                buildDomain(ruleDictionary, ruleIDNAEncodedComponents);
            }
        }
        
        [ruleDictionary setObject:@{} forKey:@"*"];
        
        NSString *srcRoot = [NSString stringWithUTF8String:getenv("SRCROOT")];
        NSString *filePath = [srcRoot stringByAppendingString:@"/KKDomain/Resources/etld.plist"];
        
        [ruleDictionary writeToFile:filePath atomically:YES];
        
    }
    return 0;
}

