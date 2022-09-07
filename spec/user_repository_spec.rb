require 'user_repository'
require 'user'


RSpec.describe UserRepository do
  def reset_users_table
    seed_sql = File.read('spec/seeds_social_network.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end
  
  describe UserRepository do
    before(:each) do 
      reset_users_table
    end

    it 'outputs a list of all users from the database' do

      repo = UserRepository.new

      users = repo.all

      expect(users.length).to eq 2

      expect(users[0].id).to eq '1'
      expect(users[0].name).to eq 'David'
      expect(users[0].email).to eq 'david@makers.com'

      expect(users[1].id).to eq '2'
      expect(users[1].name).to eq 'Anna'
      expect(users[1].email).to eq 'anna@makers.com'
    end
    
    it "returns a single user object when given an id" do
      repo = UserRepository.new
      user = repo.find(1)

      expect(user.id).to eq '1'
      expect(user.name).to eq 'David'
      expect(user.email).to eq 'david@makers.com'
    end

    it "creates a new user entry in the database" do
      repo = UserRepository.new
      user = User.new
      user.name = 'Jane'
      user.email = 'jane@makers.com'

      repo.create(user)

      expect(repo.all.last.name).to eq 'Jane'
      expect(repo.all.last.email).to eq 'jane@makers.com'
    end

    it "deletes an entry in the database with the given id" do
      repo = UserRepository.new
      repo.delete(1)
      
      expect(repo.all.length).to eq 1
      expect(repo.all.first.id).to eq '2'
      expect(repo.all.first.name).to eq 'Anna'
      expect(repo.all.first.email).to eq 'anna@makers.com'
    end

    it "updates an entry in the database" do
      repo = UserRepository.new

      user = repo.find(1)
      user.email = 'david@gmail.com'
      repo.update(user)

      updated_user = repo.find(1)
      expect(updated_user.email).to eq 'david@gmail.com'
    end
  end
end