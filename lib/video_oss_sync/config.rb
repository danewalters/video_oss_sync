module VideoOssSync
  class Config
    attr_accessor :access_key_id, :access_key_secret, :endpoint,
                  :bucket_name, :download_limit, :upload_limit

    def initialize
      @download_limit = nil    # bytes per second
      @upload_limit   = nil    # bytes per second
    end
  end
end
