$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sqlite3'
require 'rspec'
require 'active_record'
require 'allow_mass_assignment_of'

require 'rspec/rails/adapters'
require 'rspec/rails/fixture_support'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Base.configurations = true

File.open('spec.log', 'w').close
ActiveRecord::Base.logger = Logger.new('spec.log')

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define :version => 1 do
  create_table :post do |t|
    t.string  :title
    t.text    :body
    t.integer :category_id
    t.timestamps
  end

  create_table :categories do |t|
    t.string :name
  end
end

RSpec.configure do |config|
  config.use_transactional_examples = true

  config.before :each do
    class ::Category < ActiveRecord::Base
      has_many :posts
    end

    class ::Post < ActiveRecord::Base
      belongs_to :category
      attr_accessible :title, :body
    end
  end

  config.after :each do
    Object.send :remove_const, :Post
    Object.send :remove_const, :Category
  end
end

