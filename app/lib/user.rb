require 'json'

class User
  USERS = JSON.load(File.read("#{__dir__}/../../db/users.json"))
  
  def self.add(email, name)
    File.open("#{__dir__}/../../db/users.json", "w") do |f|
      USERS[email] = {"name" => name}
      f.write(JSON.pretty_generate(USERS))
    end
  end
end