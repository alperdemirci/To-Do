#s line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!
inhibit_all_warnings!

target 'To Do' do
    pod 'SwiftyJSON', :git =>'https://github.com/SwiftyJSON/SwiftyJSON.git'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Firebase/Storage'
    pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
    pod 'FoldingCell', :git=> 'https://github.com/stephangopaul/folding-cell.git', :branch => 'swift3'
        
target 'To DoTests' do
        inherit! :search_paths
        pod 'Firebase/Core'
        pod 'Firebase/Messaging'
        pod 'Firebase/Database'
        pod 'Firebase/Auth'
        #       pod 'SwiftyJSON', '~> 3.0.0'
    end

    target 'To DoUITests' do
        inherit! :search_paths

    end
end
