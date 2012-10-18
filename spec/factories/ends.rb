# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :end do
    match
    position 1
    our_score 5
    their_score nil
  end
end
