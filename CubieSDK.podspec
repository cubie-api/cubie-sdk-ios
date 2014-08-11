Pod::Spec.new do |s|

   s.name         = 'CubieSDK'
   s.version      = '0.0.1'
   s.summary      = 'Cubie SDK enables 3rd party apps to connect to Cubie and send messages'
   s.homepage     = 'http://cubie.com'
   s.license      = 'Apache License, Version 2.0'
   s.author       = { 'Cubie' => 'cubie-admin@cubie.com' }
   s.source       = { :git => 'https://github.com/cubie-api/cubie-sdk-ios.git',
                     :tag => '0.0.1'}
   s.requires_arc = true

   s.ios.deployment_target = '6.0'
   s.ios.frameworks   = 'UIKit','Foundation'

   s.dependency 'AFNetworking', '~> 2.3.1'
   s.dependency 'JSONKit-NoWarning', '~> 1.2'
   s.dependency 'CocoaLumberjack', '~> 1.9.1'

   s.private_header_files = 'sdk/internal/*.h'
   s.source_files = 'sdk/**/*.{h,m}'

end
