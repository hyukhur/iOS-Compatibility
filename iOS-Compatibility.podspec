Pod::Spec.new do |s|
  s.name         = "iOS-Compatibility"
  s.version      = "0.0.1"
  s.summary      = "iOS-Compatibility supports iOS API Compatibility in the runtime and has some Compatibility tools."
  s.description  = <<-DESC
we supports iOS API Compatibility with the slow and rough implementations in the runtime, and has some Compatibility tools.
                    DESC
  s.homepage     = "https://github.com/hyukhur/iOS-Compatibility"
  s.license      = 'FreeBSD License'
  s.author       = { "Hyuk Hur" => "hyukhur@gmail.com"}
  s.source       = { :git => "https://github.com/hyukhur/iOS-Compatibility.git", :tag => "0.0.1" }
  s.platform     = :ios
  s.source_files = 'Classes', 'Classes/**/*.{h,m}', 'HHCompatibility/**/*.{h,m}'
  s.public_header_files = 'HHCompatibility/HHCompatibility.h'
  s.frameworks = 'AssetsLibrary'
  s.requires_arc = true
end
