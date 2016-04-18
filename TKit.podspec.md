Pod::Spec.new do |s|
s.name         = "RKAlertView"
s.version      = "1.0.1"
s.summary      = "The package of useful tools, include categories and classes"
s.homepage     = "http://rookie.org.cn/"
s.license      = "MIT"
s.authors      = { 'tangjr' => 'Rookie_liu@126.com'}
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/Rookie-liu/RKAlertView", :tag => s.version }
s.source_files = 'TKit', 'TKit/**/*.{h,m}'
s.requires_arc = true
end