platform :ios, '8.0'
use_frameworks!

def shared_pod
    pod 'Mixpanel', '~> 2.3.5'
    pod 'AFNetworking'
    pod 'PQFCustomLoaders'
    pod 'JWGCircleCounter', '~>  0.2.2'
    pod 'TTTAttributedLabel', '~> 1.9.5'
    pod 'Reachability'
    pod 'JNKeychain'
end

target :Kiosk do
    shared_pod
end

target :'Kiosk QA' do
    shared_pod
end

