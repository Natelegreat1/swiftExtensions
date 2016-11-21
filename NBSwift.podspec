Pod::Spec.new do |spec|
  spec.name = "NBSwift"
  spec.version = "1.0.0"
  spec.summary = "Swift extensions framework"
  spec.homepage = "https://github.com/Natelegreat1/swiftExtensions"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Nathaniel" => 'nathanielblumer@gmail.com' }

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/Natelegreat1/swiftExtensions.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "NBSwift/**/*.{h,swift}"
end