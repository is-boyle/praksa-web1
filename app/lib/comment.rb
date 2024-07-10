require 'json'

class Comment
    COMMENTS = JSON.load(File.read("#{__dir__}/../../db/comments.json"))

    def self.add (email, body)
        f = File.open("#{__dir__}/../../db/comments.json", "w")
        COMMENTS["comments"].push({email => {"timestamp" => Time.now, "comment" => body}})
        f.write(JSON.pretty_generate(COMMENTS))
        f.close()
    end

    # private
    
    # def get_json (name)
    #     f = File.open("#{__dir__}/../../db/comments.json", "w")
    # end
end