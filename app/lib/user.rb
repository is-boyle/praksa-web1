# require 'json'
require './lib/database'


class User
  # USERS = JSON.load(File.read("#{__dir__}/../../db/users.json"))
  USERS = Database::DB[:users]
  
  def self.add(email, name, password)
    # File.open("#{__dir__}/../../db/users.json", "w") do |f|
    #   USERS[email] = {"name" => name, "password" => password}
    #   f.write(JSON.pretty_generate(USERS))
    # end
    USERS.insert([:email, :name, :password], [email, name, password])
  end

  def self.get ()
    return USERS.all
  end

  def self.get_user_by_id (id)
    return USERS.where(id: id).first[:email]
  end

  def self.exists(email)
    # return USERS.key?(email)
    return (USERS.where(email: email).count != 0)
  end

  def self.checkpwd(email, password)
    # return USERS[email]["password"].eql?(password)
    return (USERS.where(email: email).first[:password].eql?(password))
  end
end