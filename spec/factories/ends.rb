# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :end do
    match
    our_score { rand(8) }
    their_score { rand(8) }
  end
end
