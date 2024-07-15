require './lib/database'

class Comment
    COMMENTS = Database::DB[:comments]

    def self.add (email, body)
        COMMENTS.insert([:email, :timestamp, :comment], [email, Time.now, body])
    end

    def self.get ()
        return COMMENTS.all
    end
end