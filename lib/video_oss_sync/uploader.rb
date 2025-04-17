require "aliyun/oss"

module VideoOssSync
  class Uploader
    MIN_BPS = 819_200
    MAX_BPS = 838_860_800
    CHUNK   = 64 * 1024 # 64 KiB

    def initialize(config, limit: nil)
      @config = config
      @limit  = limit # bytes per second
    end

    def upload(file_path, object_key)
      client = Aliyun::OSS::Client.new(
        endpoint:          @config.endpoint,
        access_key_id:     @config.access_key_id,
        access_key_secret: @config.access_key_secret
      )
      bucket = client.get_bucket(@config.bucket_name)

      opts = build_header_opts

      File.open(file_path, "rb") do |io|
        bucket.put_object(object_key, opts) do |stream|
          # StreamWriter only implements `<<`; not a full IO.
          while (chunk = io.read(CHUNK))
            stream << chunk
          end
        end
      end
      true
    end

    private

    def build_header_opts
      return {} unless @limit && @limit.positive?
      bps = (@limit * 8).to_i
      unless bps.between?(MIN_BPS, MAX_BPS)
        raise ArgumentError, "upload_limit must be between #{MIN_BPS / 8} and #{MAX_BPS / 8} bytes/s"
      end
      { headers: { 'x-oss-traffic-limit' => bps.to_s } }
    end
  end
end
