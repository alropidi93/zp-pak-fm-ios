# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Against ibdesignables error
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

target 'pak-ios' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for pak-ios

  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'GoogleMaps'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'NVActivityIndicatorView'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Tabman'
  pod 'SDWebImage'
  pod 'ImageSlideshow'
  pod 'ImageSlideshow/Kingfisher'
  pod 'Cosmos'
  pod 'RLBAlertsPickers', :git => 'https://github.com/loicgriffie/Alerts-Pickers.git', :branch => 'master'
  pod 'SwiftHash'
  pod 'IQKeyboardManagerSwift'
  pod 'AKMediaViewer'
  pod 'Agrume'
  pod 'SideMenu'
  pod 'TTGSnackbar'
  pod 'PlayerKit'
  pod 'BmoViewPager'
  pod 'GoogleSignIn'
  pod 'MIBadgeButton-Swift', :git => 'https://github.com/mustafaibrahim989/MIBadgeButton-Swift.git', :branch => 'master'
  pod 'SwipeCellKit'
  pod 'AFNetworking', '~> 3.0'
end
