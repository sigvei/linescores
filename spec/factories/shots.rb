# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shot do
    association :end, factory: :end
    team "us"
    rock 1
    call "D"
    turn "I"
    success 100
    player "Thomas Ulsrud"
  end
end
