Pod::Spec.new do |s|
  s.name         = "VaultSDK"

  s.version      = "0.0.1"

  s.summary      = "Vault SDK."

  s.description  = "SDK for credit card tokenization via Vault "

  s.homepage     = "https://github.com/william/vault-ios-sdk"

  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }

  s.author       = { "williamlocke" => "williamlocke@me.com" }

  s.source       = { :git => "https://github.com/williamlocke/vault-ios-sdk.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  
  s.dependency 'ATNetworking'
  
  s.resources = '{Vault.podspec}'  

  s.source_files =  'Classes/**/*.[h,m]'
  
  s.requires_arc = true

end
