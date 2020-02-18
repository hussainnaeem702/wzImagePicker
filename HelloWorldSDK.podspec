Pod::Spec.new do |s|
  s.name          = "WZImagePickerSDK"
  s.version       = "0.0.1"
  s.summary       = "iOS SDK for ImagePicker"
  s.description   = "iOS SDK for ImagePicker, including example app"
  s.homepage      = "https://github.com/peteranny/"
  s.license       = "MIT"
  s.author        = "peteranny"
  s.platform      = :ios, "9.0"
  s.swift_version = "4.2"
  s.source        = {
    :git => "https://github.com/peteranny/HelloWorldSDK.git",
    :tag => "#{s.version}"
  }
  s.source_files        = "HelloWorldSDK/**/*.{h,m,swift}"
  s.public_header_files = "HelloWorldSDK/**/*.h"
end
