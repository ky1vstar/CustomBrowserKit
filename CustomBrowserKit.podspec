Pod::Spec.new do |s|
  s.name             = 'CustomBrowserKit'
  s.version          = '1.0'
  s.summary          = 'Let your users open links in their favorite browser'

  s.description      = <<-DESC
CustomBrowserKit is a library designed to provide ability to open links in browser besides Safari to your awesome app's users. It is written in Objective-C and extended with Swift.
                       DESC

  s.homepage         = 'https://github.com/ky1vstar/CustomBrowserKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ky1vstar' => 'ky1vstar@yandex.ru' }
  s.source           = { :git => 'https://github.com/ky1vstar/CustomBrowserKit.git', :tag => s.version.to_s }

  s.platform = :ios
  s.ios.deployment_target = '8.0'

  s.requires_arc = true
  # s.swift_version = '4.0'
  s.resources = 'Source/*.xcassets'
  
  s.public_header_files = 'Source/*.{h}'
  s.source_files = [
    'Source/*.{h,m,swift}',
    'Source/Private/*.{h,m}'
  ]

  s.frameworks = 'UIKit'
end
