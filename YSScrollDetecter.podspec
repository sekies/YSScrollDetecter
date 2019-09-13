
Pod::Spec.new do |spec|

  spec.name         = "YSScrollDetecter"
  spec.version      = "0.0.1"
  spec.summary      = "YSScrollDetecter."
  spec.homepage     = "https://github.com/sekies/YSScrollDetecter"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Yosuke Seki" => "y.sekies@gmail.com" }
  spec.source       = { :git => "https://github.com/sekies/YSScrollDetecter.git", :tag => "#{spec.version}" }
  spec.platform     = :ios, '10.0'
  spec.source_files  = "YSScrollDetecter/**/*.{h,m,swift}"
  spec.swift_versions = "5"

end
