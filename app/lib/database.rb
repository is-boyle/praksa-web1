class Database
  DB = Sequel.sqlite('./db/comments.sqlite')
  
  def self.initialize()

    DB.create_table?(:comments) do
      primary_key :id
      String :email
      Time :timestamp
      String :comment
    end

    DB.create_table?(:users) do
      primary_key :id
      String :email
      String :name
      String :password
    end

  end
end