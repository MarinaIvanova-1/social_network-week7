require 'post_repository'
require 'post'


RSpec.describe PostRepository do
  def reset_posts_table
    seed_sql = File.read('spec/seeds_social_network.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end
  
  describe PostRepository do
    before(:each) do 
      reset_posts_table
    end

    it 'outputs a list of all posts' do

      repo = PostRepository.new

      posts = repo.all

      expect(posts.length).to eq 2

      expect(posts[0].id).to eq '1'
      expect(posts[0].title).to eq 'First Day'
      expect(posts[0].content).to eq 'Today was a great day.'
      expect(posts[0].number_of_views).to eq'132'
      expect(posts[0].user_id).to eq '1'

      expect(posts[1].id).to eq '2'
      expect(posts[1].title).to eq 'Learning SQL'
      expect(posts[1].content).to eq 'I have learned so much.'
      expect(posts[1].number_of_views).to eq'472'
      expect(posts[1].user_id).to eq '2'
    end

    it 'finds a record with a given id' do
      repo = PostRepository.new

      post = repo.find(1)
      
      expect(post.id).to eq '1'
      expect(post.title).to eq 'First Day'
      expect(post.content).to eq 'Today was a great day.'
      expect(post.number_of_views).to eq '132'
      expect(post.user_id).to eq '1'
    end

    it 'creates a record with given data' do
      repo = PostRepository.new

      post = Post.new
      post.title = 'Golden square'
      post.content = 'OOD and TDD'
      post.number_of_views = 245
      post.user_id = 2

      repo.create(post)

      expect(repo.all.last.title).to eq 'Golden square'
      expect(repo.all.last.content).to eq'OOD and TDD'
    end

    it 'deletes a record with a given id' do
      repo = PostRepository.new

      repo.delete(1)

      expect(repo.all.length).to eq 1
      expect(repo.all.first.id).to eq '2'
      expect(repo.all.first.title).to eq 'Learning SQL'
      expect(repo.all.first.content).to eq 'I have learned so much.'
    end

    it 'updates a record with given data' do
      repo = PostRepository.new

      post = repo.find(1)
      post.content = 'Today was HARD!'
      repo.update(post)

      updated_post = repo.find(1)

      expect(updated_post.content).to eq 'Today was HARD!'
    end
  end
end