//
//  KKDomainTests.m
//  KKDomainTests
//
//  Created by Luke on 4/6/14.
//  Copyright (c) 2014 geeklu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+KKDomain.h"

@interface KKDomainTests : XCTestCase

@end

@implementation KKDomainTests
BOOL checkRegisteredDomain(NSString *source,NSString *result){
    NSString *tld = [source registeredDomain];
    if (tld == nil && result == nil) {
        return YES;
    }
    if ([tld isEqualToString:result]) {
        return YES;
    }
    return NO;
}

BOOL checkPublicSuffix(NSString *source,NSString *result){
    NSString *tld = [source publicSuffix];
    if (tld == nil && result == nil) {
        return YES;
    }
    if ([tld isEqualToString:result]) {
        return YES;
    }
    return NO;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDomains
{
    
    //测试数据来自 http://mxr.mozilla.org/mozilla-central/source/netwerk/test/unit/data/test_psl.txt?raw=1
    
    // Any copyright is dedicated to the Public Domain.
    // http://creativecommons.org/publicdomain/zero/1.0/
    
    // nil input.
    XCTAssertTrue(checkRegisteredDomain(nil, nil));
    // Mixed case.
    XCTAssertTrue(checkRegisteredDomain(@"COM", nil));
    XCTAssertTrue(checkRegisteredDomain(@"example.COM",@"example.com"));
    XCTAssertTrue(checkRegisteredDomain(@"WwW.example.COM",@"example.com"));
    // Leading dot.
    XCTAssertTrue(checkRegisteredDomain(@".com", nil));
    XCTAssertTrue(checkRegisteredDomain(@".example", nil));
    XCTAssertTrue(checkRegisteredDomain(@".example.com", nil));
    XCTAssertTrue(checkRegisteredDomain(@".example.example", nil));
    // Unlisted TLD.
    XCTAssertTrue(checkRegisteredDomain(@"example", nil));
    XCTAssertTrue(checkRegisteredDomain(@"example.example",@"example.example"));
    XCTAssertTrue(checkRegisteredDomain(@"b.example.example",@"example.example"));
    XCTAssertTrue(checkRegisteredDomain(@"a.b.example.example",@"example.example"));
    // Listed, but non-Internet, TLD.
    //XCTAssertTrue(checkPublicSuffix(@"local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"example.local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"b.example.local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"a.b.example.local", nil));
    // TLD with only 1 rule.
    XCTAssertTrue(checkRegisteredDomain(@"biz", nil));
    XCTAssertTrue(checkRegisteredDomain(@"domain.biz",@"domain.biz"));
    XCTAssertTrue(checkRegisteredDomain(@"b.domain.biz",@"domain.biz"));
    XCTAssertTrue(checkRegisteredDomain(@"a.b.domain.biz",@"domain.biz"));
    // TLD with some 2-level rules.
    XCTAssertTrue(checkRegisteredDomain(@"com", nil));
    XCTAssertTrue(checkRegisteredDomain(@"example.com",@"example.com"));
    XCTAssertTrue(checkRegisteredDomain(@"b.example.com",@"example.com"));
    XCTAssertTrue(checkRegisteredDomain(@"a.b.example.com",@"example.com"));
    XCTAssertTrue(checkRegisteredDomain(@"uk.com", nil));
    XCTAssertTrue(checkRegisteredDomain(@"example.uk.com",@"example.uk.com"));
    XCTAssertTrue(checkRegisteredDomain(@"b.example.uk.com",@"example.uk.com"));
    XCTAssertTrue(checkRegisteredDomain(@"a.b.example.uk.com",@"example.uk.com"));
    XCTAssertTrue(checkRegisteredDomain(@"test.ac",@"test.ac"));
    // TLD with only 1 (wildcard) rule.
    XCTAssertTrue(checkRegisteredDomain(@"cy", nil));
    XCTAssertTrue(checkRegisteredDomain(@"c.cy", nil));
    XCTAssertTrue(checkRegisteredDomain(@"b.c.cy",@"b.c.cy"));
    XCTAssertTrue(checkRegisteredDomain(@"a.b.c.cy",@"b.c.cy"));
    // More complex TLD.
    XCTAssertTrue(checkRegisteredDomain(@"jp", nil));
    XCTAssertTrue(checkRegisteredDomain(@"test.jp",@"test.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"www.test.jp",@"test.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"ac.jp", nil));
    XCTAssertTrue(checkRegisteredDomain(@"test.ac.jp",@"test.ac.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"www.test.ac.jp",@"test.ac.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"kyoto.jp", nil));
    XCTAssertTrue(checkRegisteredDomain(@"test.kyoto.jp",@"test.kyoto.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"ide.kyoto.jp", nil));
    XCTAssertTrue(checkRegisteredDomain(@"b.ide.kyoto.jp",@"b.ide.kyoto.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"a.b.ide.kyoto.jp",@"b.ide.kyoto.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"c.kobe.jp", nil));
    XCTAssertTrue(checkRegisteredDomain(@"b.c.kobe.jp",@"b.c.kobe.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"a.b.c.kobe.jp",@"b.c.kobe.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"city.kobe.jp",@"city.kobe.jp"));
    XCTAssertTrue(checkRegisteredDomain(@"www.city.kobe.jp",@"city.kobe.jp"));
    // TLD with a wildcard rule and exceptions.
    XCTAssertTrue(checkRegisteredDomain(@"ck", nil));
    XCTAssertTrue(checkRegisteredDomain(@"test.ck", nil));
    XCTAssertTrue(checkRegisteredDomain(@"b.test.ck",@"b.test.ck"));
    XCTAssertTrue(checkRegisteredDomain(@"a.b.test.ck",@"b.test.ck"));
    XCTAssertTrue(checkRegisteredDomain(@"www.ck",@"www.ck"));
    XCTAssertTrue(checkRegisteredDomain(@"www.www.ck",@"www.ck"));
    // US K12.
    XCTAssertTrue(checkRegisteredDomain(@"us", nil));
    XCTAssertTrue(checkRegisteredDomain(@"test.us",@"test.us"));
    XCTAssertTrue(checkRegisteredDomain(@"www.test.us",@"test.us"));
    XCTAssertTrue(checkRegisteredDomain(@"ak.us", nil));
    XCTAssertTrue(checkRegisteredDomain(@"test.ak.us",@"test.ak.us"));
    XCTAssertTrue(checkRegisteredDomain(@"www.test.ak.us",@"test.ak.us"));
    XCTAssertTrue(checkRegisteredDomain(@"k12.ak.us", nil));
    XCTAssertTrue(checkRegisteredDomain(@"test.k12.ak.us",@"test.k12.ak.us"));
    XCTAssertTrue(checkRegisteredDomain(@"www.test.k12.ak.us",@"test.k12.ak.us"));
    // IDN labels.
    XCTAssertTrue(checkRegisteredDomain(@"食狮.com.cn",@"食狮.com.cn"));
    XCTAssertTrue(checkRegisteredDomain(@"食狮.公司.cn",@"食狮.公司.cn"));
    XCTAssertTrue(checkRegisteredDomain(@"www.食狮.公司.cn",@"食狮.公司.cn"));
    XCTAssertTrue(checkRegisteredDomain(@"shishi.公司.cn",@"shishi.公司.cn"));
    XCTAssertTrue(checkRegisteredDomain(@"公司.cn", nil));
    XCTAssertTrue(checkRegisteredDomain(@"食狮.中国",@"食狮.中国"));
    XCTAssertTrue(checkRegisteredDomain(@"www.食狮.中国",@"食狮.中国"));
    XCTAssertTrue(checkRegisteredDomain(@"shishi.中国",@"shishi.中国"));
    XCTAssertTrue(checkRegisteredDomain(@"中国", nil));
    // Same as above, but punycoded.
    XCTAssertTrue(checkRegisteredDomain(@"xn--85x722f.com.cn",@"xn--85x722f.com.cn"));
    XCTAssertTrue(checkRegisteredDomain(@"xn--85x722f.xn--55qx5d.cn",@"xn--85x722f.xn--55qx5d.cn"));
    XCTAssertTrue(checkRegisteredDomain(@"www.xn--85x722f.xn--55qx5d.cn",@"xn--85x722f.xn--55qx5d.cn"));
    XCTAssertTrue(checkRegisteredDomain(@"shishi.xn--55qx5d.cn",@"shishi.xn--55qx5d.cn"));
    XCTAssertTrue(checkRegisteredDomain(@"xn--55qx5d.cn", nil));
    XCTAssertTrue(checkRegisteredDomain(@"xn--85x722f.xn--fiqs8s",@"xn--85x722f.xn--fiqs8s"));
    XCTAssertTrue(checkRegisteredDomain(@"www.xn--85x722f.xn--fiqs8s",@"xn--85x722f.xn--fiqs8s"));
    XCTAssertTrue(checkRegisteredDomain(@"shishi.xn--fiqs8s",@"shishi.xn--fiqs8s"));
    XCTAssertTrue(checkRegisteredDomain(@"xn--fiqs8s", nil));
    
    
    
    
    // nil input.
    XCTAssertTrue(checkPublicSuffix(nil, nil));
    // Mixed case.
    XCTAssertTrue(checkPublicSuffix(@"COM", @"com"));
    XCTAssertTrue(checkPublicSuffix(@"example.COM",@"com"));
    XCTAssertTrue(checkPublicSuffix(@"WwW.example.COM",@"com"));
    // Leading dot.
    XCTAssertTrue(checkPublicSuffix(@".com", @"com"));
    XCTAssertTrue(checkPublicSuffix(@".example", @"example"));
    XCTAssertTrue(checkPublicSuffix(@".example.com", @"com"));
    XCTAssertTrue(checkPublicSuffix(@".example.example", @"example"));
    // Unlisted TLD.
    XCTAssertTrue(checkPublicSuffix(@"example", @"example"));
    XCTAssertTrue(checkPublicSuffix(@"example.example",@"example"));
    XCTAssertTrue(checkPublicSuffix(@"b.example.example",@"example"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.example.example",@"example"));
    // Listed, but non-Internet, TLD.
    //XCTAssertTrue(checkPublicSuffix(@"local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"example.local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"b.example.local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"a.b.example.local", nil));
    // TLD with only 1 rule.
    XCTAssertTrue(checkPublicSuffix(@"biz", @"biz"));
    XCTAssertTrue(checkPublicSuffix(@"domain.biz",@"biz"));
    XCTAssertTrue(checkPublicSuffix(@"b.domain.biz",@"biz"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.domain.biz",@"biz"));
    // TLD with some 2-level rules.
    XCTAssertTrue(checkPublicSuffix(@"com", @"com"));
    XCTAssertTrue(checkPublicSuffix(@"example.com",@"com"));
    XCTAssertTrue(checkPublicSuffix(@"b.example.com",@"com"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.example.com",@"com"));
    XCTAssertTrue(checkPublicSuffix(@"uk.com", @"uk.com"));
    XCTAssertTrue(checkPublicSuffix(@"example.uk.com",@"uk.com"));
    XCTAssertTrue(checkPublicSuffix(@"b.example.uk.com",@"uk.com"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.example.uk.com",@"uk.com"));
    XCTAssertTrue(checkPublicSuffix(@"test.ac",@"ac"));
    // TLD with only 1 (wildcard) rule.
    XCTAssertTrue(checkPublicSuffix(@"cy", @"cy"));
    XCTAssertTrue(checkPublicSuffix(@"c.cy", @"c.cy"));
    XCTAssertTrue(checkPublicSuffix(@"b.c.cy",@"c.cy"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.c.cy",@"c.cy"));
    // More complex TLD.
    XCTAssertTrue(checkPublicSuffix(@"jp", @"jp"));
    XCTAssertTrue(checkPublicSuffix(@"test.jp",@"jp"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.jp",@"jp"));
    XCTAssertTrue(checkPublicSuffix(@"ac.jp", @"ac.jp"));
    XCTAssertTrue(checkPublicSuffix(@"test.ac.jp",@"ac.jp"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.ac.jp",@"ac.jp"));
    XCTAssertTrue(checkPublicSuffix(@"kyoto.jp", @"kyoto.jp"));
    XCTAssertTrue(checkPublicSuffix(@"test.kyoto.jp",@"kyoto.jp"));
    XCTAssertTrue(checkPublicSuffix(@"ide.kyoto.jp", @"ide.kyoto.jp"));
    XCTAssertTrue(checkPublicSuffix(@"b.ide.kyoto.jp",@"ide.kyoto.jp"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.ide.kyoto.jp",@"ide.kyoto.jp"));
    XCTAssertTrue(checkPublicSuffix(@"c.kobe.jp", @"c.kobe.jp"));
    XCTAssertTrue(checkPublicSuffix(@"b.c.kobe.jp",@"c.kobe.jp"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.c.kobe.jp",@"c.kobe.jp"));
    XCTAssertTrue(checkPublicSuffix(@"city.kobe.jp",@"kobe.jp"));
    XCTAssertTrue(checkPublicSuffix(@"www.city.kobe.jp",@"kobe.jp"));
    // TLD with a wildcard rule and exceptions.
    XCTAssertTrue(checkPublicSuffix(@"ck", @"ck"));
    XCTAssertTrue(checkPublicSuffix(@"test.ck", @"test.ck"));
    XCTAssertTrue(checkPublicSuffix(@"b.test.ck",@"test.ck"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.test.ck",@"test.ck"));
    XCTAssertTrue(checkPublicSuffix(@"www.ck",@"ck"));
    XCTAssertTrue(checkPublicSuffix(@"www.www.ck",@"ck"));
    // US K12.
    XCTAssertTrue(checkPublicSuffix(@"us", @"us"));
    XCTAssertTrue(checkPublicSuffix(@"test.us",@"us"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.us",@"us"));
    XCTAssertTrue(checkPublicSuffix(@"ak.us", @"ak.us"));
    XCTAssertTrue(checkPublicSuffix(@"test.ak.us",@"ak.us"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.ak.us",@"ak.us"));
    XCTAssertTrue(checkPublicSuffix(@"k12.ak.us", @"k12.ak.us"));
    XCTAssertTrue(checkPublicSuffix(@"test.k12.ak.us",@"k12.ak.us"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.k12.ak.us",@"k12.ak.us"));
    // IDN labels.
    XCTAssertTrue(checkPublicSuffix(@"食狮.com.cn",@"com.cn"));
    XCTAssertTrue(checkPublicSuffix(@"食狮.公司.cn",@"公司.cn"));
    XCTAssertTrue(checkPublicSuffix(@"www.食狮.公司.cn",@"公司.cn"));
    XCTAssertTrue(checkPublicSuffix(@"shishi.公司.cn",@"公司.cn"));
    XCTAssertTrue(checkPublicSuffix(@"公司.cn", @"公司.cn"));
    XCTAssertTrue(checkPublicSuffix(@"食狮.中国",@"中国"));
    XCTAssertTrue(checkPublicSuffix(@"www.食狮.中国",@"中国"));
    XCTAssertTrue(checkPublicSuffix(@"shishi.中国",@"中国"));
    XCTAssertTrue(checkPublicSuffix(@"中国", @"中国"));
    // Same as above, but punycoded.
    XCTAssertTrue(checkPublicSuffix(@"xn--85x722f.com.cn",@"com.cn"));
    XCTAssertTrue(checkPublicSuffix(@"xn--85x722f.xn--55qx5d.cn",@"xn--55qx5d.cn"));
    XCTAssertTrue(checkPublicSuffix(@"www.xn--85x722f.xn--55qx5d.cn",@"xn--55qx5d.cn"));
    XCTAssertTrue(checkPublicSuffix(@"shishi.xn--55qx5d.cn",@"xn--55qx5d.cn"));
    XCTAssertTrue(checkPublicSuffix(@"xn--55qx5d.cn", @"xn--55qx5d.cn"));
    XCTAssertTrue(checkPublicSuffix(@"xn--85x722f.xn--fiqs8s",@"xn--fiqs8s"));
    XCTAssertTrue(checkPublicSuffix(@"www.xn--85x722f.xn--fiqs8s",@"xn--fiqs8s"));
    XCTAssertTrue(checkPublicSuffix(@"shishi.xn--fiqs8s",@"xn--fiqs8s"));
    XCTAssertTrue(checkPublicSuffix(@"xn--fiqs8s", @"xn--fiqs8s"));
}


@end
