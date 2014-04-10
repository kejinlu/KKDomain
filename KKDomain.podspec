Pod::Spec.new do |s|
  s.name     = 'KKDomain'
  s.version  = '0.0.1'
  s.license  = 'BSD / Apache License, Version 2.0'
  s.homepage = 'https://github.com/kejinlu/KKDomain'
  s.summary  = 'A objc library which gives access to the PSL (Public Suffix List)'
  s.author   = '卢克'
  s.source   = { 
  	:git => 'https://github.com/kejinlu/KKDomain.git', 
  	branch => 'master' 
  }

  s.source_files   = "KKDomain/*.{h,m}"
  spec.resource = "KKDomain/Resources/etld.plist"
  s.requires_arc  = true
end
