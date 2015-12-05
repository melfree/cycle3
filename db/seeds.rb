# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

user_data = [
            {email: "one@andrew.cmu.edu", name: "User One"},
            {email: "two@andrew.cmu.edu", name: "User Two"},
            {email: "three@andrew.cmu.edu", name: "User Three"},
            {email: "four@andrew.cmu.edu", name: "User Four"},
            {email: "five@andrew.cmu.edu", name: "User Four"},
            {email: "six@andrew.cmu.edu", name: "User Six"},
            {email: "seven@andrew.cmu.edu", name: "User Seven"},
            {email: "eight@andrew.cmu.edu", name: "User Eight"},
            {email: "nine@andrew.cmu.edu", name: "User Nine"}]

for hash in user_data
  user = User.new(hash.merge({password: "password", password_confirmation: "password"}))
  
  user.latitude = rand * (User::N_BOUND-User::S_BOUND) + User::S_BOUND
  user.longitude = rand * (User::E_BOUND-User::W_BOUND) + User::W_BOUND
  user.location_code = rand(0..2)
  
  # Skip registration confirmation email step
  user.skip_confirmation!
  
  user.save!
end

# Update records randomly to create some matches.
User.all.to_a.each_with_index do |u, index|
  
  u.status_code = index % 3
  
  if user_data.size / 2 < index
    # Last few users will not be matched automatically
    u.meal_plan_code = index % 3
  else
    # These users will be matched automatically
    u.meal_plan_code = 0
  end
  
  u.save!
end