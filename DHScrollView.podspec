
Pod::Spec.new do |spec|

  spec.name         = "DHScrollView"
  spec.version      = "0.0.2"
  spec.summary      = "A Auto Move Banner Scroll View."

  spec.description  = <<-DESC
  Auto Move Banner Scroll View. Can be triggered by gesture
                   DESC

  spec.homepage     = "https://github.com/a408486727/DHScrollView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "XuChuanqi" => "408486727@qq.com" }
  spec.source       = { :git => "https://github.com/a408486727/DHScrollView.git", :tag => "#{spec.version}" }
  spec.source_files  = "DHScrollView/**/*.{h,m}"
  spec.ios.deployment_target = '8.0'
end
