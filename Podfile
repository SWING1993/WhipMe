source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!
target "WhipMe" do

pod 'SnapKit'
#pod 'SVProgressHUD'
#pod 'Alamofire'
#pod 'SDWebImage'
#pod 'BlocksKit'
#pod 'TMCache'
#pod 'TTTAttributedLabel'
#pod 'TPKeyboardAvoiding'
#pod 'MJRefresh'
#pod 'MJExtension'
#pod 'RxSwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
