platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'Tangem Id' do
	
	# UI
	pod 'InputMask'
	
	# Network
	pod 'Moya'
	
	# DI
	pod 'Swinject'
	
	# Internal sdk
	pod 'TangemSdk', :git => 'https://github.com/tangem/tangem-sdk-ios', :tag => 'build-71'
	pod 'BlockchainSdk', :git => 'https://github.com/tangem/blockchain-sdk-swift', :tag => 'build-39'

    pod 'BinanceChain', :git => 'https://github.com/lazutkin-andrey/swiftbinancechain.git', :tag => '0.0.8'
    pod 'web3swift', :git => 'https://github.com/lazutkin-andrey/web3swift.git', :tag => '2.2.6'
    pod 'HDWalletKit', :git => 'https://github.com/lazutkin-andrey/hdwallet.git', :tag => '0.3.12'
end

pre_install do |installer|
	# workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
	Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			if Gem::Version.new('9.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
			end
		end
	end
end

target 'Tangem IdTests' do
    pod 'TangemSdk', :git => 'https://github.com/tangem/tangem-sdk-ios', :tag => 'build-71'
    pod 'BlockchainSdk', :git => 'https://github.com/tangem/blockchain-sdk-swift', :tag => 'build-39'
end
