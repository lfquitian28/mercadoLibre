#
# Be sure to run `pod lib lint ProductsSearch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ProductsSearch'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ProductsSearch.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lfquitian8@gmail.com/ProductsSearch'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lfquitian8@gmail.com' => 'ext_lfquitianc@falabella.cl' }
  s.source           = { :git => 'https://github.com/lfquitian8@gmail.com/ProductsSearch.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'ProductsSearch/Module/**/*.{swift,m,h}'
  
    s.resources = "ProductsSearch/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}"
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'ProductsSearch/Tests/**/*.{swift,.m,.h}'
    
    test_spec.dependency 'Quick'
    test_spec.dependency 'Nimble'
    test_spec.dependency 'iOSSnapshotTestCase'
 end
  
  # s.resource_bundles = {
  #   'ProductsSearch' => ['ProductsSearch/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Networking'
  
end
