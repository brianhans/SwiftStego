Pod::Spec.new do |s|
  s.name             = 'SwiftStego'
  s.version          = '0.1.0'
  s.summary          = 'A steganography library written in Swift.'
  s.description      = <<-DESC
A simple library that allows users to obsecure data in an image.
                       DESC
  s.homepage         = 'https://github.com/brianhans/SwiftStego'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brianhans' => 'wbrianw8@gmail.com' }
  s.source           = { :git => 'https://github.com/brianhans/SwiftStego.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = "Source/*.swift"
end
