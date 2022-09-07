require_relative './user'
require_relative './database_connection'


class UserRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT id, name, email FROM users;'
    result_list = DatabaseConnection.exec_params(sql, [])
    users = []
    result_list.each do |record|
      user = User.new
      user.id = record['id']
      user.name = record['name']
      user.email = record['email']
      users << user
    end
    return users
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, email FROM users WHERE id = $1;

    # Returns a single User object.
  end


  # Creates a new record
  def create(user)
    # Executes the SQL query:
    # INSERT INTO users (name, email) VALUES ($1, $2);

    # returns nil
  end

  # Deletes a record
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM users WHERE id = $1;

    # returns nil
  end  
  
  # Updates a record given
  def update(user)
    # Executes the SQL query:
    # UPDATE users SET name = $1, email = $2 WHERE id = $3;

    # returns nil
  end
end