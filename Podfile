# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Traveller' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!
  pod 'Alamofire', '~> 5.2'
  pod 'AlamofireImage', '~> 4.1'

  # Pods for Traveller

  target 'TravellerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TravellerUITests' do
    # Pods for testing
  end

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
    end
end
