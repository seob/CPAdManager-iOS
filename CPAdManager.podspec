#
#  Be sure to run `pod spec lint CPAdManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CPAdManager"
  s.version      = "0.0.1"
  s.summary      = "Mobile ads rolling"
  s.description  = <<-DESC
  복수개의 모바일 광고를 사용하여 수익을 올릴려고 할때 도움이 되는 라이브러리
                   DESC
  s.homepage     = "https://github.com/yoonhg84/CPAdManager-iOS"

  s.license      = "MIT"
  s.author             = { "yoonhg84" => "yoonhg2002@gmail.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/yoonhg84/CPAdManager-iOS.git", :tag => "v#{s.version}" }
  s.source_files = "Classes", "Classes/**/*.swift"

  s.requires_arc = true

  s.ios.dependency 'Firebase/Core'
  s.ios.dependency 'Firebase/AdMob'
  s.dependency 'FBAudienceNetwork'

  # s.resource_bundles = { 'GoogleMobileAdsSDK' => ['Pods/Google-Mobile-Ads-SDK/GoogleMobileAdsSDK.framework/Resources/*.bundle'] }
  s.vendored_frameworks = 'Pods/Google-Mobile-Ads-SDK/Frameworks/GoogleMobileAds.framework', 'Pods/FBAudienceNetwork/FBAudienceNetwork.framework'
  s.xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => 'Pod/Dependencies' }
end