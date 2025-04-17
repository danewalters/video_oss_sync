require "net/http"
require "uri"

module VideoOssSync
  class Downloader
    DEFAULT_CHUNK = 64 * 1024 # 64 KiB

    def initialize(limit: nil)
      @limit = limit # bytes per second
    end

    def download(url, dest)
      uri = URI.parse(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request_get(uri.request_uri) do |response|
          raise "HTTP #{response.code}" unless response.code.to_i == 200

          File.open(dest, "wb") do |file|
            throttle_stream(response) { |chunk| file.write(chunk) }
          end
        end
      end
      dest
    end

    private

    def throttle_stream(response)
      bytes  = 0
      start  = Time.now
      response.read_body do |chunk|
        yield chunk
        bytes += chunk.bytesize
        regulate(bytes, start)
      end
    end

    def regulate(bytes, start)
      return unless @limit && @limit.positive?
      elapsed  = Time.now - start
      allowed  = @limit * elapsed
      if bytes > allowed
        sleep((bytes - allowed).to_f / @limit)
      end
    end
  end
end
