# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :match do
    opponent "MyString"
    time "2012-10-01 11:00:43"
    location "MyString"
    tournament "MyString"

    factory :match_with_ends do
      ignore do
        ends_count 6
      end

      after(:create) do |match, evaluator|
        FactoryGirl.create_list(:end, evaluator.ends_count, match: match)
      end
    end
  end

end
