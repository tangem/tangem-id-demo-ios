platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'Tangem Id' do
	
	# UIKit
	pod 'InputMask'
	
	# Network
	pod 'Moya'
	
	# DI
	pod 'Swinject'
	
	# Internal sdk
	pod 'TangemSdk', :git => 'git@bitbucket.org:tangem/card-sdk-swift.git', :branch => 'master'
	pod 'BlockchainSdk', :git => 'git@bitbucket.org:tangem/blockchain-sdk-swift.git', :branch => 'master'
	pod 'BinanceChain', :git => 'https://bitbucket.org/tangem/swiftbinancechain.git', :tag => '0.0.6'
	pod 'web3swift', :git => 'https://bitbucket.org/tangem/web3swift.git', :tag => '2.2.3'
	pod 'HDWalletKit', :git => 'https://bitbucket.org/tangem/hdwallet.git', :tag => '0.3.8'
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
	pod 'TangemSdk', :git => 'git@bitbucket.org:tangem/card-sdk-swift.git', :branch => 'master'
	pod 'BlockchainSdk', :git => 'git@bitbucket.org:tangem/blockchain-sdk-swift.git', :branch => 'master'
end
