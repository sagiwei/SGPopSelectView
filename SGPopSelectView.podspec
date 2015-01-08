Pod::Spec.new do |s|
  s.name         = "SGPopSelectView"
  s.version      = "0.2"
  s.summary      = "A simple beautiful popup view for single selection."
  s.description  = "A simple beautiful popup view for single selection, adjust size to fit it's content and also superview."
  s.homepage     = "https://github.com/sagiwei/SGPopSelectView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "sagiwei" => "sagiwei@gmail.com" }

  s.source       = { :git => "https://github.com/sagiwei/SGPopSelectView.git", :tag => "v0.2" }
  s.source_files = "classes/*.{h,m}"
  s.resources    = 'classes/sg_pop_images.xcassets'

  s.platform = :ios, '6.0'
  s.framework = 'UIKit'
  s.requires_arc = true
end
