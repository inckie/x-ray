# frozen_string_literal: true
package = JSON.parse(File.read(File.join("../package.json")))
version = package['version']

Pod::Spec.new do |s|
  s.name = 'Reporter'
  s.version = version
  s.summary = 'Logger Reporter'
  s.ios.deployment_target = '14.0'
  s.tvos.deployment_target = '14.0'
  s.swift_versions = '5.5'
  s.description = <<-DESC
  'Applicaster Logger'
  DESC

  s.homepage = 'git@github.com:applicaster/x-ray.git'
  s.license = 'Appache 2.0'
  s.author = { 'a.kononenko@applicaster.com' => 'a.kononenko@applicaster.com' }
  s.source = { git: 'git@github.com:applicaster/x-ray.git', tag: version }
  s.dependency 'XrayLogger'
  s.ios.source_files = [
    'Extensions/Reporter/**/*.{swift}'
  ]
  s.tvos.source_files = 'Extensions/Reporter/dummy.swift'
  
end
