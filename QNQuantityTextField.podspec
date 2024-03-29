#
# Be sure to run `pod lib lint QNQuantityTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QNQuantityTextField'
  s.version          = '1.3.1'
  s.summary          = 'Support input number type double, interger, format display by custom local'
  s.swift_version = '5.0'


# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Support input number type double, interger, format display by custom local
                       DESC

  s.homepage         = 'https://github.com/quannguyen90/QNQuantityTextField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'quannguyen90' => 'quannv.tm@gmail.com' }
  s.source           = { :git => 'https://github.com/quannguyen90/QNQuantityTextField.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.resources = ["MoMoVoucher/Fonts/*.{OTF,ttf}", 'MoMoVoucher/Assets/**/*.{png,pdf}']

  s.source_files = 'QNQuantityTextField/Classes/**/*'
  s.resources = ["QNQuantityTextField/Fonts/*.{OTF,ttf}", 'QNQuantityTextField/Assets/**/*.{png,pdf}']
#  s.resource_bundles = {
#     'QNQuantityTextField' => ['QNQuantityTextField/Assets/*.xcassets']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
#  /Users/quannv/Documents/Projects/iOSLibs/QNQuantityTextField/QNQuantityTextField/Media.xcassets
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
