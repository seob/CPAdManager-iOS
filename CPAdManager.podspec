#
#  Be sure to run `pod spec lint CPAdManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CPAdManager"
  s.version      = "1.5.0"
  s.summary      = "Mobile AD Mediation"
  s.description  = <<-DESC
  복수개의 모바일 광고를 사용하여 수익을 올릴려고 할때 도움이 되는 라이브러리
                   DESC
  s.homepage     = "https://github.com/yoonhg84/CPAdManager-iOS"

  s.license      = "MIT"
  s.author       = { "yoonhg84" => "yoonhg2002@gmail.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/yoonhg84/CPAdManager-iOS.git", :tag => "#{s.version}" }
  s.ios.source_files = "Source/*.swift", "Source/**/*.swift"

  s.requires_arc = true

  s.prepare_command = <<-CMD
        directoryName='CPAdManager-Frameworks'
        rm -rf ${directoryName}
        mkdir -p ${directoryName}
        downloadFrameworkZipFile() {
            local podspecFilename=$(pod spec which $1)
            echo ${podspecFilename}
            local zipURL=$(cat ${podspecFilename} | grep '"http"' | grep -E '(https)' | awk '{print $2}' | cut -d'"' -f2)
            echo ${zipURL}
            curl -L -o $1 ${zipURL}
        }
        cd ${directoryName}
        #downloadFrameworkZipFile FBAudienceNetwork
        #unzip FBAudienceNetwork
        downloadFrameworkZipFile Google-Mobile-Ads-SDK
        tar -xvzf Google-Mobile-Ads-SDK
        mv -f 'Frameworks/frameworks/GoogleMobileAds.framework' .
        pwd
        ls -al
        cd ..
    CMD

  #s.dependency 'KVOController'
  #s.libraries = 'c++.tbd', 'xml2'
  s.ios.frameworks = 'AudioToolbox','StoreKit','CoreGraphics','UIKit','Foundation','Security','CoreImage','AVFoundation','CoreMedia','CoreMotion','CoreTelephony','CoreVideo','GLKit','MediaPlayer','MessageUI','MobileCoreServices','OpenGLES','SystemConfiguration'
  s.weak_frameworks = 'AdSupport','CoreMotion','SafariServices','WebKit','JavaScriptCore'
  s.ios.vendored_frameworks = 'AdPlatforms/FBAudience_*/FBAudienceNetwork.framework', 'CPAdManager-Frameworks/GoogleMobileAds.framework'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '3.2'
  }
end
