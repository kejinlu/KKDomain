//
//  main.m
//  ETLDPlistGenerator
//
//  Created by Luke on 4/6/14.
//  Copyright (c) 2014 geeklu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSStringPunycodeAdditions.h"

void buildETLDRuleTree(NSMutableDictionary *node, NSMutableArray *domainParts){
    if ([domainParts count] ==0) {
        return;
    }
    
    NSString *lastDomainPart = [domainParts lastObject];
    [domainParts removeLastObject];
    
    BOOL notDomain = NO;
    if ([lastDomainPart hasPrefix:@"!"]) {
        notDomain = YES;
        lastDomainPart = [lastDomainPart substringFromIndex:1];
    }
    
    NSMutableDictionary *childNode = node[lastDomainPart];
    if (!childNode) {
        childNode = [NSMutableDictionary dictionary];
        if (notDomain) {
            [childNode setObject:@{} forKey:@"!"];
        }
        [node setObject:childNode forKey:lastDomainPart];
    }
    
    if (!notDomain && [domainParts count] > 0) {
        buildETLDRuleTree(childNode, domainParts);
    }
}

/*
 此target的目的是构建 KKDomain所依赖的用于描述 Public Suffix规则的plist文件
 项目中默认已经生成了一份plist文件，如果需要更新plist文件，则在项目中运行此target
 目标文件输出到$(SRCROOT)/KKDomain/Resources/etld.plist  
 SRCROOT环境变量是预先设置在target的环境变量中的
 */
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
            buildETLDRuleTree(ruleDictionary, ruleComponents);
            
            if (![ruleLine isEqualToString:ruleLineIDNAEncoded]) {
                NSMutableArray *ruleIDNAEncodedComponents = [[ruleLineIDNAEncoded componentsSeparatedByString:@"."] mutableCopy];
                buildETLDRuleTree(ruleDictionary, ruleIDNAEncodedComponents);
            }
        }
        
        [ruleDictionary setObject:@{} forKey:@"*"];
        
        NSString *srcRoot = [NSString stringWithUTF8String:getenv("SRCROOT")];
        NSString *filePath = [srcRoot stringByAppendingString:@"/KKDomain/Resources/etld.plist"];
        
        [ruleDictionary writeToFile:filePath atomically:YES];
        
    }
    return 0;
}

