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
  
  end
end