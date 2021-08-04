#
# Be sure to run `pod lib lint ISUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ISUtils'
  s.version          = '0.1.9'
  s.summary          = 'A short description of ISUtils.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sjustfly/ISUtils'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sjustfly' => 'luochao_p@126.com' }
  s.source           = { :git => 'https://github.com/sjustfly/ISUtils.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ISUtils/Classes/*'
  
  s.dependency 'Masonry'
  s.frameworks = 'Foundation', 'UIKit'
  
#  s.subspec 'NSString' do |bb|
#      bb.source_files = 'ISUtils/Classes/NSString/*'
#      bb.frameworks = 'Foundation'
#  end
#
#  s.subspec 'Other' do |cc|
#      cc.source_files = 'ISUtils/Classes/Other/*'
#      cc.frameworks = 'Foundation', 'UIKit'
#      cc.dependency 'Masonry'
#  end
#
#  s.subspec 'UIButton' do |dd|
#      dd.source_files = 'ISUtils/Classes/UIButton/*'
#      dd.frameworks = 'Foundation', 'UIKit'
#  end
#
#  s.subspec 'UIColor' do |ee|
#      ee.source_files = 'ISUtils/Classes/UIColor/*'
#      ee.frameworks = 'Foundation'
#  end
#
#  s.subspec 'UIImage' do |ff|
#      ff.source_files = 'ISUtils/Classes/UIImage/*'
#      ff.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'
#  end
#
#  s.subspec 'UINavigationItem' do |gg|
#      gg.source_files = 'ISUtils/Classes/UINavigationItem/*'
#      gg.frameworks = 'Foundation', 'UIKit'
#  end
#
#  s.subspec 'UITextField' do |hh|
#      hh.source_files = 'ISUtils/Classes/UITextField/*'
#      hh.frameworks = 'Foundation', 'UIKit'
#  end
#
#  s.subspec 'UITextView' do |ii|
#      ii.source_files = 'ISUtils/Classes/UITextView/*'
#      ii.frameworks = 'Foundation', 'UIKit'
#  end
#
#  s.subspec 'UIView' do |jj|
#      jj.source_files = 'ISUtils/Classes/UIView/*'
#      jj.frameworks = 'Foundation', 'UIKit'
#      jj.dependency 'Masonry'
#  end
#
end
