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
BOOL checkPublicSuffix(NSString *source,NSString *result){
    NSString *tld = [source registeredDomain];
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
    XCTAssertTrue(checkPublicSuffix(nil, nil));
    // Mixed case.
    XCTAssertTrue(checkPublicSuffix(@"COM", nil));
    XCTAssertTrue(checkPublicSuffix(@"example.COM",@"example.com"));
    XCTAssertTrue(checkPublicSuffix(@"WwW.example.COM",@"example.com"));
    // Leading dot.
    XCTAssertTrue(checkPublicSuffix(@".com", nil));
    XCTAssertTrue(checkPublicSuffix(@".example", nil));
    XCTAssertTrue(checkPublicSuffix(@".example.com", nil));
    XCTAssertTrue(checkPublicSuffix(@".example.example", nil));
    // Unlisted TLD.
    XCTAssertTrue(checkPublicSuffix(@"example", nil));
    XCTAssertTrue(checkPublicSuffix(@"example.example",@"example.example"));
    XCTAssertTrue(checkPublicSuffix(@"b.example.example",@"example.example"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.example.example",@"example.example"));
    // Listed, but non-Internet, TLD.
    //XCTAssertTrue(checkPublicSuffix(@"local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"example.local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"b.example.local", nil));
    //XCTAssertTrue(checkPublicSuffix(@"a.b.example.local", nil));
    // TLD with only 1 rule.
    XCTAssertTrue(checkPublicSuffix(@"biz", nil));
    XCTAssertTrue(checkPublicSuffix(@"domain.biz",@"domain.biz"));
    XCTAssertTrue(checkPublicSuffix(@"b.domain.biz",@"domain.biz"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.domain.biz",@"domain.biz"));
    // TLD with some 2-level rules.
    XCTAssertTrue(checkPublicSuffix(@"com", nil));
    XCTAssertTrue(checkPublicSuffix(@"example.com",@"example.com"));
    XCTAssertTrue(checkPublicSuffix(@"b.example.com",@"example.com"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.example.com",@"example.com"));
    XCTAssertTrue(checkPublicSuffix(@"uk.com", nil));
    XCTAssertTrue(checkPublicSuffix(@"example.uk.com",@"example.uk.com"));
    XCTAssertTrue(checkPublicSuffix(@"b.example.uk.com",@"example.uk.com"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.example.uk.com",@"example.uk.com"));
    XCTAssertTrue(checkPublicSuffix(@"test.ac",@"test.ac"));
    // TLD with only 1 (wildcard) rule.
    XCTAssertTrue(checkPublicSuffix(@"cy", nil));
    XCTAssertTrue(checkPublicSuffix(@"c.cy", nil));
    XCTAssertTrue(checkPublicSuffix(@"b.c.cy",@"b.c.cy"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.c.cy",@"b.c.cy"));
    // More complex TLD.
    XCTAssertTrue(checkPublicSuffix(@"jp", nil));
    XCTAssertTrue(checkPublicSuffix(@"test.jp",@"test.jp"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.jp",@"test.jp"));
    XCTAssertTrue(checkPublicSuffix(@"ac.jp", nil));
    XCTAssertTrue(checkPublicSuffix(@"test.ac.jp",@"test.ac.jp"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.ac.jp",@"test.ac.jp"));
    XCTAssertTrue(checkPublicSuffix(@"kyoto.jp", nil));
    XCTAssertTrue(checkPublicSuffix(@"test.kyoto.jp",@"test.kyoto.jp"));
    XCTAssertTrue(checkPublicSuffix(@"ide.kyoto.jp", nil));
    XCTAssertTrue(checkPublicSuffix(@"b.ide.kyoto.jp",@"b.ide.kyoto.jp"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.ide.kyoto.jp",@"b.ide.kyoto.jp"));
    XCTAssertTrue(checkPublicSuffix(@"c.kobe.jp", nil));
    XCTAssertTrue(checkPublicSuffix(@"b.c.kobe.jp",@"b.c.kobe.jp"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.c.kobe.jp",@"b.c.kobe.jp"));
    XCTAssertTrue(checkPublicSuffix(@"city.kobe.jp",@"city.kobe.jp"));
    XCTAssertTrue(checkPublicSuffix(@"www.city.kobe.jp",@"city.kobe.jp"));
    // TLD with a wildcard rule and exceptions.
    XCTAssertTrue(checkPublicSuffix(@"ck", nil));
    XCTAssertTrue(checkPublicSuffix(@"test.ck", nil));
    XCTAssertTrue(checkPublicSuffix(@"b.test.ck",@"b.test.ck"));
    XCTAssertTrue(checkPublicSuffix(@"a.b.test.ck",@"b.test.ck"));
    XCTAssertTrue(checkPublicSuffix(@"www.ck",@"www.ck"));
    XCTAssertTrue(checkPublicSuffix(@"www.www.ck",@"www.ck"));
    // US K12.
    XCTAssertTrue(checkPublicSuffix(@"us", nil));
    XCTAssertTrue(checkPublicSuffix(@"test.us",@"test.us"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.us",@"test.us"));
    XCTAssertTrue(checkPublicSuffix(@"ak.us", nil));
    XCTAssertTrue(checkPublicSuffix(@"test.ak.us",@"test.ak.us"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.ak.us",@"test.ak.us"));
    XCTAssertTrue(checkPublicSuffix(@"k12.ak.us", nil));
    XCTAssertTrue(checkPublicSuffix(@"test.k12.ak.us",@"test.k12.ak.us"));
    XCTAssertTrue(checkPublicSuffix(@"www.test.k12.ak.us",@"test.k12.ak.us"));
    // IDN labels.
    XCTAssertTrue(checkPublicSuffix(@"食狮.com.cn",@"食狮.com.cn"));
    XCTAssertTrue(checkPublicSuffix(@"食狮.公司.cn",@"食狮.公司.cn"));
    XCTAssertTrue(checkPublicSuffix(@"www.食狮.公司.cn",@"食狮.公司.cn"));
    XCTAssertTrue(checkPublicSuffix(@"shishi.公司.cn",@"shishi.公司.cn"));
    XCTAssertTrue(checkPublicSuffix(@"公司.cn", nil));
    XCTAssertTrue(checkPublicSuffix(@"食狮.中国",@"食狮.中国"));
    XCTAssertTrue(checkPublicSuffix(@"www.食狮.中国",@"食狮.中国"));
    XCTAssertTrue(checkPublicSuffix(@"shishi.中国",@"shishi.中国"));
    XCTAssertTrue(checkPublicSuffix(@"中国", nil));
    // Same as above, but punycoded.
    XCTAssertTrue(checkPublicSuffix(@"xn--85x722f.com.cn",@"xn--85x722f.com.cn"));
    XCTAssertTrue(checkPublicSuffix(@"xn--85x722f.xn--55qx5d.cn",@"xn--85x722f.xn--55qx5d.cn"));
    XCTAssertTrue(checkPublicSuffix(@"www.xn--85x722f.xn--55qx5d.cn",@"xn--85x722f.xn--55qx5d.cn"));
    XCTAssertTrue(checkPublicSuffix(@"shishi.xn--55qx5d.cn",@"shishi.xn--55qx5d.cn"));
    XCTAssertTrue(checkPublicSuffix(@"xn--55qx5d.cn", nil));
    XCTAssertTrue(checkPublicSuffix(@"xn--85x722f.xn--fiqs8s",@"xn--85x722f.xn--fiqs8s"));
    XCTAssertTrue(checkPublicSuffix(@"www.xn--85x722f.xn--fiqs8s",@"xn--85x722f.xn--fiqs8s"));
    XCTAssertTrue(checkPublicSuffix(@"shishi.xn--fiqs8s",@"shishi.xn--fiqs8s"));
    XCTAssertTrue(checkPublicSuffix(@"xn--fiqs8s", nil));
}


@end
