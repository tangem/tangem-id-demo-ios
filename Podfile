platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'Tangem Id' do
    pod 'Moya'
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

target 'Tangem IdTests' do
    pod 'TangemSdk', :git => 'git@bitbucket.org:tangem/card-sdk-swift.git', :branch => 'master'
    pod 'BlockchainSdk', :git => 'git@bitbucket.org:tangem/blockchain-sdk-swift.git', :branch => 'master'
end
