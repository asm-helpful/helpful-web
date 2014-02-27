# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    message
    file { File.new(Rails.root.join('app', 'assets', 'images', 'logo.png'))}
  end
end
