FactoryGirl.define do

  factory :foo, class: FooServer do
    sequence(:bar) { |n| "foo ##{n}" }
  end

end
