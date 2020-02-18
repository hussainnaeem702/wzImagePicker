Pod::Spec.new do |s|
  s.name          = "WZImagePickerSDK"
  s.version       = "0.0.1"
  s.summary       = "iOS SDK for ImagePicker"
  s.description   = "iOS SDK for ImagePicker, including example app"
  s.homepage      = "https://github.com/hussainnaeem702/
  s.license       = "MIT"
  s.author        = "peteranny"
  s.platform      = :ios, "11.0"
  s.swift_version = "5.0"
  s.source        = {
    :git => "https://github.com/hussainnaeem702/wzImagePicker.git",
    :tag => "#{s.version}"
  }
  s.source_files        = "WZImagePickerSDK/**/*.{h,m,swift}"
  s.public_header_files = "WZImagePickerSDK/**/*.h"
end
