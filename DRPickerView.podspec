Pod::Spec.new do |s|

  s.name         = "DRPickerView"
  s.version      = "0.1.0"
  s.summary      = "A simple UIView subclass that wraps UIDatePicker and UIPickerView in a single view."

  s.description  = <<-DESC
                   DRPickerView is a simple UIView subclass that wraps both UIDatePicker and UIPickerView objects and provides a nice working picker.
                   DESC

  s.homepage     = "http://github.com/Legoless/DRPickerView"
  s.license      = 'MIT'
  s.author       = { "Dal Rupnik" => "legoless@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/Legoless/DRPickerView.git", :tag => "0.1.0" }

  s.source_files = 'DRPickerView/*.{h,m}'
  s.requires_arc = true

  s.dependency 'Haystack'
end
