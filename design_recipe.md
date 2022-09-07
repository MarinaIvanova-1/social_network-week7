# Social Network Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).


```

| Record                | Properties          |
| --------------------- | ------------------  |
| user                  | name, email
| post                  | title, content, number_of_views
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql


TRUNCATE TABLE users RESTART IDENTITY;

INSERT INTO users (name, email) VALUES ('David', 'david@makers.com');
INSERT INTO users (name, email) VALUES ('Anna', 'anna@makers.com');



TRUNCATE TABLE posts RESTART IDENTITY;

INSERT INTO posts (title, content, number_of_views, user_id) VALUES ('First Day', 'Today was a great day.', 132, 1);
INSERT INTO posts (title, content, number_of_views, user_id) VALUES ('Learning SQL', 'I have learned so much.', 472, 2);



```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
class User
end

class UserRepository
end

class Post
end

class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
class User
  attr_accessor :id, :name, :email
end

class Post
  attr_accessor :id, :title, :content, :number_of_views, :user_id
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby


class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, email FROM users;

    # Returns an array of User objects.
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
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all users

repo = UserRepository.new

users = repo.all

users.length # =>  2

users[0].id # =>  1
users[0].name # =>  'David'
users[0].email # =>  'david@makers.com'

users[1].id # =>  2
users[1].name # =>  'Anna'
users[1].email # =>  'anna@makers.com'

# 2
# Get a single user

repo = UserRepository.new

user = repo.find(1)

user.id # =>  1
user.name # =>  'David'
user.email # =>  'david@makers.com'

# 3
# Create a single user

repo = UserRepository.new

user = User.new
user.name = 'Jane'
user.email = 'jane@makers.com'

repo.create(user)

repo.all.last.name # => 'Jane'
repo.all.last.email # => 'jane@makers.com'

# 4
# Delete a single user

repo = UserRepository.new

repo.delete(1)

repo.all.length #=> 1
repo.all.first.id # => '2'
repo.all.first.name # => 'Anna'
repo.all.first.email # => 'anna@makers.com'

# 5
# Update a single user

repo = UserRepository.new

user = repo.find(1)
user.email = 'david@gmail.com'
repo.update(user)

updated_user = repo.find(1)
updated_user.email # => 'david@gmail.com'




# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_repository_spec.rb

def reset_users_table
  seed_sql = File.read('spec/seeds_users.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._