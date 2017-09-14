require "crystagiri"
require "http/client"
require "process"

module Random
  class LgtmDotIn

    LGTM_DOT_IN_URL         = "https://www.lgtm.in"
    TRY_FETCHING_META_LIMIT = 3

    def fetch_random_lgtm_image
      url   = "#{LGTM_DOT_IN_URL}/g"
      limit = TRY_FETCHING_META_LIMIT
      random_lgtm_img = ""
      response = HTTP::Client.get(url)
      if response.status_code == 302
        random_lgtm_url = response.headers["Location"].to_s
      end
      if random_lgtm_url
        doc = Crystagiri::HTML.from_url(random_lgtm_url)
        num = 0
        doc.where_tag("img") do |tag|
          if num == 1
            random_lgtm_img = tag.node["src"]
          end
          num +=1
        end
      end
      random_lgtm_img
    end

  end
end

img = Random::LgtmDotIn.new.fetch_random_lgtm_image
puts "Open #{img} with default browser..."
cmd = "sh"
args = [] of String
args << "-c" << "open #{img} | bash"
Process.run(cmd, args)
