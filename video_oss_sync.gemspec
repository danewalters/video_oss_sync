Gem::Specification.new do |spec|
  spec.name          = "video_oss_sync"
  spec.version       = "0.1.1"
  spec.summary       = "Download video from URL and upload to Alibaba Cloud OSS with rate limiting"
  spec.description   = spec.summary
  spec.authors       = ["Dane Wang"]
  spec.email         = ["dwalters.maruko@gmil.com"]
  spec.files         = Dir["lib/**/*.rb"]
  spec.required_ruby_version = ">= 2.7"

  # ---- Dependency fix ----
  # Use the official OSS SDK gem name. This provides `require \"aliyun/oss\"`.
  spec.add_dependency "aliyun-sdk", "~> 0.8"

  spec.license                     = "MIT"
  spec.metadata["homepage_uri"]    = "https://github.com/danewalters/video_oss_sync"
end
