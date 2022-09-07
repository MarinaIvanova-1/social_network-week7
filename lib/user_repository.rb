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
    sql = "SELECT id, name, email FROM users WHERE id = $1;"
    result_list = DatabaseConnection.exec_params(sql, [id])
    record = result_list.first
    user = User.new
    user.id = record['id']
    user.name = record['name']
    user.email = record['email']

    return user
  end


  # Creates a new record
  def create(user)
    sql = "INSERT INTO users (name, email) VALUES ($1, $2);"
    DatabaseConnection.exec_params(sql, [user.name, user.email])

    return nil
  end

  # Deletes a record
  def delete(id)
    sql = "DELETE FROM users WHERE id = $1;"
    DatabaseConnection.exec_params(sql, [id])

    return nil
  end  
  
  # Updates a record given
  def update(user)
    sql = "UPDATE users SET name = $1, email = $2 WHERE id = $3;"
    params = [user.name, user.email, user.id]
    DatabaseConnection.exec_params(sql, params)

    return nil
  end
end