# frozen_string_literal: true
package = JSON.parse(File.read(File.join("../package.json")))
version = package['version']

Pod::Spec.new do |s|
  s.name = 'XrayLogger'
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
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'XrayLogger/**/*.{swift}'
  end

  s.subspec 'ReactNative' do |sp|
    sp.dependency 'React'
    sp.dependency 'React-Core'

    sp.source_files = [
      'ReactNative/**/*.{swift}',
      'ReactNative/ReactNativeModulesExports.m'
    ]
  end
end
