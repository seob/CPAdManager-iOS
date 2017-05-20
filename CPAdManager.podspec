#
#  Be sure to run `pod spec lint CPAdManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CPAdManager"
  s.version      = "1.0.0"
  s.summary      = "Mobile AD Mediation"
  s.description  = <<-DESC
  복수개의 모바일 광고를 사용하여 수익을 올릴려고 할때 도움이 되는 라이브러리
                   DESC
  s.homepage     = "https://github.com/yoonhg84/CPAdManager-iOS"

  s.license      = "MIT"
  s.author       = { "yoonhg84" => "yoonhg2002@gmail.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/yoonhg84/CPAdManager-iOS.git", :tag => "#{s.version}" }
  s.source_files = "Source", "Source/**/*.swift"

  s.requires_arc = true

  s.ios.vendored_frameworks = 'AdPlatforms/FBAudienceNetwork.framework', 'AdPlatforms/GoogleMobileAds.framework'

end