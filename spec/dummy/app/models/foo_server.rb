class FooServer < ActiveRecord::Base
  self.table_name = 'foos'
  attr_accessible :bar
end
