# frozen_string_literal: true

Pod::Spec.new do |s|
  s.name = 'xray'
  s.version = '0.0.1'
  s.summary = 'Applicaster Logger'
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.swift_versions = '5.1'
  s.description = <<-DESC
  'Applicaster Logger'
  DESC

  s.homepage = 'git@github.com:applicaster/x-ray.git'
  s.license = 'Appache 2.0'
  s.author = { 'a.kononenko@applicaster.com' => 'a.kononenko@applicaster.com' }
  s.source = { git: 'git@github.com:applicaster/x-ray.git', tag: '0.0.1' }

  s.source_files = 'xray/**/*.{swift}'

  # s.subspec 'ReactNative' do |sp|
  #   sp.dependency 'React'

  #   sp.source_files = [
  #     'ReactNative/**/*.{swift}',
  #     'ReactNative/ReactNativeModulesExports.m'
  #   ]
  # end

  s.subspec 'Reporter' do |sp|
    sp.source_files = [
      'Extensions/Reporter/**/*.{swift}'
    ]
  end
end
