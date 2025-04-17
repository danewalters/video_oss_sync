# VideoOssSync

A lightweight Ruby gem to **download a video from a public URL** and **upload it to Alibaba Cloud OSS**, with optional per‑direction bandwidth throttling.

---

## Installation

```bash
# install the gem (includes aliyun-sdk automatically)
gem install video_oss_sync
```

If you use Bundler, add this to your **application**’s Gemfile:

```ruby
gem "video_oss_sync", "~> 0.1"
```

## Quick Start

```ruby
require "video_oss_sync"

VideoOssSync.configure do |c|
  c.access_key_id     = ENV["ALIYUN_ACCESS_KEY_ID"]
  c.access_key_secret = ENV["ALIYUN_ACCESS_KEY_SECRET"]
  c.endpoint          = "https://oss-cn-shanghai.aliyuncs.com"
  c.bucket_name       = "my-bucket"

  # default limits (bytes/second)
  c.download_limit = 2 * 1024 * 1024  # 2 MB/s
  c.upload_limit   = 1 * 1024 * 1024  # 1 MB/s
end

VideoOssSync.sync(
  "https://example.com/movie.mp4",
  "videos/movie.mp4"
)
```

For per‑call limit overrides:

```ruby
VideoOssSync.sync(url, key,
  download_limit: 512 * 1024,
  upload_limit:   256 * 1024)
```

## Notes
* The gem now depends on **aliyun‑sdk (~> 0.8)**, which provides `require "aliyun/oss"`.
* Standard‑library libs (`net/http`, `uri`, `tempfile`) do **not** need to be listed in your Gemfile.
* Warnings like `rbs extensions are not built` are harmless; run `gem pristine rbs --extensions` if you’d like them gone.

## License
MIT © DaneWang
