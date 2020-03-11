
Pod::Spec.new do |spec|

  spec.name         = "DHScrollView"
  spec.version      = "0.0.1"
  spec.summary      = "A Auto Move Banner Scroll View."

  spec.description  = <<-DESC
  Auto Move Banner Scroll View.
                   DESC

  spec.homepage     = "https://github.com/a408486727/DHScrollView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "XuChuanqi" => "408486727@qq.com" }
  spec.source       = { :git => "https://github.com/a408486727/DHScrollView.git", :tag => "#{spec.version}" }
  spec.source_files  = "DHScrollView/**/*.{h,m}"

end
