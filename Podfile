# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TemizOperasyon' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TemizOperasyon

pod 'BarcodeScanner'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'Jelly'
pod 'SwiftyCam'
pod 'CollieGallery'
pod 'Kingfisher'
pod 'Firebase/Core'
pod 'Fabric', '~> 1.9.0'
pod 'Crashlytics', '~> 3.12.0'
pod 'Bagel'
pod 'IQKeyboardManager'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'TemizOperasyon'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end

  target 'TemizOperasyonTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TemizOperasyonUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
