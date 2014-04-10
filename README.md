KKDomain
========

A objc library which gives access to the [PSL](https://publicsuffix.org/) (Public Suffix List).

### What is PSL?
The Public Suffix List is intended to enumerate all domain suffixes controlled by registrars.   
A "public suffix" is also known by the older term effective top-level domain (eTLD).


### How to use KKDomain?

If you use cocoapods just

	pod 'KKDomain', :git => 'https://github.com/kejinlu/KKDomain.git'
	
else copy category files to your project

	#import "NSString+KKDomain.h"
	......
	
	NSString *host = @"www.taobao.com";
    NSLog(@"publicSuffix: %@",[host publicSuffix]);
    NSLog(@"registeredDomain: %@",[host registeredDomain]);
