Pod::Spec.new do |spec|
  spec.name = "nventive-swift"
  spec.version = "1.0.0"
  spec.summary = "Swift extensions framework"
  spec.homepage = "https://github.com/Natelegreat1/swiftExtensions"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Nathaniel" => 'nathaniel.blumer@nventive.com' }

  spec.platform = :ios, "9.1"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/Natelegreat1/swiftExtensions.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "nventive-swift/**/*.{h,swift}"
end