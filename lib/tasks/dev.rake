namespace :dev do
  task fake: :environment do
    Restaurant.destroy_all

    500.times do |i|
      Restaurant.create!(name: FFaker::Name.first_name,
        tel: FFaker::PhoneNumber.short_phone_number,
        address: FFaker::Address.street_address,
        opening_hours: FFaker::Time.datetime,
        description: FFaker::Lorem.paragraph,
        category: Category.all.sample
        )
    end
    puts "have created fake restaurants"
    puts "now you have #{Restaurant.count} restaurants data"
  end
  
end