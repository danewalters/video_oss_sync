require "aliyun/oss"

module VideoOssSync
  class Uploader
    DEFAULT_CHUNK = 64 * 1024 # 64 KiB

    def initialize(config, limit: nil)
      @config = config
      @limit  = limit
    end

    def upload(file_path, object_key)
      client = Aliyun::OSS::Client.new(
        endpoint:          @config.endpoint,
        access_key_id:     @config.access_key_id,
        access_key_secret: @config.access_key_secret
      )
      bucket = client.get_bucket(@config.bucket_name)

      File.open(file_path, "rb") do |file|
        bucket.put_object(object_key) do |stream|
          throttle_upload(file) { |chunk| stream.write(chunk) }
        end
      end
      true
    end

    private

    def throttle_upload(io)
      bytes = 0
      start = Time.now
      while (chunk = io.read(DEFAULT_CHUNK))
        yield chunk
        bytes += chunk.bytesize
        regulate(bytes, start)
      end
    end

    def regulate(bytes, start)
      return unless @limit && @limit.positive?
      elapsed = Time.now - start
      allowed = @limit * elapsed
      if bytes > allowed
        sleep((bytes - allowed).to_f / @limit)
      end
    end
  end
end
