# frozen_string_literal: true
package = JSON.parse(File.read(File.join("../package.json")))
version = package['version']

Pod::Spec.new do |s|
  s.name = 'LoggerInfo'
  s.version = version
  s.summary = 'Applicaster Logger'
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'
  s.swift_versions = '5.1'
  s.description = <<-DESC
  'Applicaster Logger'
  DESC

  s.homepage = 'git@github.com:applicaster/x-ray.git'
  s.license = 'Appache 2.0'
  s.author = { 'a.kononenko@applicaster.com' => 'a.kononenko@applicaster.com' }
  s.source = { git: 'git@github.com:applicaster/x-ray.git', tag: version }
  s.default_subspec = 'Default'

  s.ios.dependency 'XrayLogger'
  s.ios.dependency 'Reporter'

  s.subspec 'Base' do |c|
    c.ios.source_files = 'Base/**/*.{swift}'
    c.tvos.source_files = ''
  end

  s.subspec 'Default' do |c|
    c.ios.resources = [
      'Extensions/LoggerNavigationController/**/*.xib',
      'Extensions/LoggerNavigationController/**/*.png'
    ]
    c.ios.source_files = 'Extensions/LoggerNavigationController/**/*.{swift}'
    c.tvos.source_files = 'Extensions/LoggerNavigationController/dummy.swift'

    c.dependency 'LoggerInfo/Base'
    c.ios.dependency 'AccordionSwift', '2.0.5'
  end
end
