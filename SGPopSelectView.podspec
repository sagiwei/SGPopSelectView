Pod::Spec.new do |s|
  s.name         = "SGPopSelectView"
  s.version      = "0.0.1"
  s.summary      = "A simple beautiful popup view for single selection."
  s.description  = "A simple beautiful popup view for single selection, adjust size to fit it's content and also superview."
  s.homepage     = "https://github.com/sagiwei/SGPopSelectView"
  s.license      = { :type => "MIT", :file => "README.markdown" }
  s.author       = { "sagiwei" => "sagiwei@gmail.com" }

  s.source       = { :git => "https://github.com/sagiwei/SGActionView.git", :commit => "5c527050b9f8c6f8a52a420fcbd1e65b814e0d71" }
  s.source_files  = "classes/*.{h,m,xcassets}"

  s.platform = :ios, '6.0'
  s.framework = 'UIKit'
  s.requires_arc = true
end
