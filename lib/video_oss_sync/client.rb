require_relative "config"
require_relative "downloader"
require_relative "uploader"
require "tempfile"
require "uri"

module VideoOssSync
  class Client
    def initialize
      @config = Config.new
    end

    def configure
      yield @config
    end

    def sync(url, object_key, download_limit: nil, upload_limit: nil)
      raise "Bucket name is missing" unless @config.bucket_name

      download_file = Tempfile.new(["video_oss_sync", File.extname(URI.parse(url).path)])
      begin
        Downloader.new(limit: download_limit || @config.download_limit)
                  .download(url, download_file.path)

        Uploader.new(@config, limit: upload_limit || @config.upload_limit)
                .upload(download_file.path, object_key)
      ensure
        download_file.close!
      end
      true
    end

    def config
      @config
    end
  end
end
