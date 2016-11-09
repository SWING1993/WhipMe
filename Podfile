source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!
target "WhipMe" do

pod 'SnapKit'
pod 'TPKeyboardAvoiding'
pod 'MJRefresh'
pod 'MJExtension'
pod 'FlyImage',   '~> 1.0'
pod 'BlocksKit'
pod 'RxSwift',    '~> 3.0.0-beta.1'
pod 'RxCocoa',    '~> 3.0.0-beta.1'
pod 'ChameleonFramework'
pod 'SwiftDate'
pod 'SwiftyJSON'
pod 'AFNetworking'
pod 'YTKKeyValueStore'
pod 'MJExtension'

#pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
#pod 'CVCalendar'
#pod 'SVProgressHUD'
#pod 'TMCache'
#pod 'TTTAttributedLabel'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end
