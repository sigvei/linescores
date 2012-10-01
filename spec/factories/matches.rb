# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :match do
    opponent "MyString"
    time "2012-10-01 11:00:43"
    location "MyString"
    tournament "MyString"
  end
end
