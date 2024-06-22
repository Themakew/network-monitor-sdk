Pod::Spec.new do |s|
  s.name             = 'NetworkMonitor'
  s.version          = '1.0.0'
  s.summary          = 'A framework for monitoring network requests.'

  s.description      = <<-DESC
  NetworkMonitor is a framework that provides functionality to monitor and log network requests made using URLSession.
  DESC

  s.homepage         = 'https://github.com/Themakew/network-monitor-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ruyther Costa' => 'ruy_fusion@hotmail.com' }
  s.source           = { :git => 'https://github.com/Themakew/network-monitor-sdk.git', :branch => 'main' }

  s.ios.deployment_target = '10.0'

  s.source_files = 'NetworkMonitor/**/*.{swift,h,m}'

  s.swift_version = '5.0'

  s.frameworks = 'Foundation'
end
