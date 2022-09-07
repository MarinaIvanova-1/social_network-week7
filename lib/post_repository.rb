require_relative './post'
require_relative './database_connection'

class PostRepository
  def all
    sql = 'SELECT id, title, content, number_of_views, user_id FROM posts;'
    result_list = DatabaseConnection.exec_params(sql, [])
    posts = []
    result_list.each do |record|
      post = Post.new
      post.id = record['id']
      post.title = record['title']
      post.content = record['content']
      post.number_of_views = record['number_of_views']
      post.user_id = record['user_id']
      posts << post
    end
    return posts
  end

  def find(id)
    sql = 'SELECT id, title, content, number_of_views, user_id FROM posts WHERE id = $1;'
    result_list = DatabaseConnection.exec_params(sql, [id])
    record = result_list[0]
    post = Post.new
    post.id = record['id']
    post.title = record['title']
    post.content = record['content']
    post.number_of_views = record['number_of_views']
    post.user_id = record['user_id']
    return post
  end

  def create(post)
    sql_param = [post.title, post.content, post.number_of_views, post.user_id]
    sql = 'INSERT INTO posts (title, content, number_of_views, user_id) VALUES ($1, $2, $3, $4);'
    DatabaseConnection.exec_params(sql, sql_param)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1;'
    DatabaseConnection.exec_params(sql, [id])

    return nil
  end  

  def update(post)
    sql = 'UPDATE posts SET title = $1, content = $2, number_of_views = $3, user_id = $4 WHERE id = $5'
    sql_param = [post.title, post.content, post.number_of_views, post.user_id, post.id]
    DatabaseConnection.exec_params(sql, sql_param)

    return nil
  end
end