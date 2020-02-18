Pod::Spec.new do |s|
  s.name          = "WZImagePickerSDK"
  s.version       = "1.0.0"
  s.summary       = "iOS SDK for ImagePicker"
  s.description   = "iOS SDK for ImagePicker, including example app"
  s.homepage      = "https://github.com/hussainnaeem702/
  s.swift_version = "5.0"
  s.source        = {
    :git => "https://github.com/hussainnaeem702/wzImagePicker.git",
    :tag => "1.0.0"
  }
  s.source_files        = "WzPicker/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
