require_relative "video_oss_sync/version"
require_relative "video_oss_sync/client"

module VideoOssSync
  class << self
    def client
      @client ||= Client.new
    end

    def configure(&block)
      client.configure(&block)
    end

    def sync(*args, **kwargs)
      client.sync(*args, **kwargs)
    end
  end
end
