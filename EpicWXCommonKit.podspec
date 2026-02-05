Pod::Spec.new do |s|
  s.name         = 'EpicWXCommonKit'
  s.version      = '0.1.0'
  s.summary      = 'Common utilities for Epic Unity integration'
  s.description  = 'Provides common UI components and utilities including logging, toast, loading view, error view, and host config.'
  s.homepage     = 'https://getepic.com'
  s.license      = { :type => 'Proprietary' }
  s.author       = 'Epic'
  s.platform     = :ios, '12.2'
  s.source       = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'

  s.resources = 'Resources/**/*',
                'Assets/**/*'
  
  s.dependency 'WXToolKit'
  s.dependency 'YYKit'
  s.dependency 'Masonry'
  s.dependency 'SDWebImage'
  s.dependency 'WXPreload'
  s.dependency 'SSZipArchive'
end
