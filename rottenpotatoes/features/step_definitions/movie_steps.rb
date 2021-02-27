# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #fail "Unimplemented"
  page.body.index(e1).should < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rates=rating_list.split(",")
  rates.each do |rate|
    if uncheck
      uncheck("ratings_#{rate}")
    else
      check("ratings_#{rate}")
    end
  end
  #fail "Unimplemented"
end
When ('I press Refresh') do
  find("#ratings_submit").click()
end
Then /(.*) I should (not?) see "(.*)"/ do|notsee, movie_name| 
  movie_name.gsub! '"',''
  if notsee
    page.should_not have_content(movie_name)
  else
    page.should have_content(movie_name)
  end
end
Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  expect(all("table#movies.table.table-striped.col-md-12/tbody/tr").count).to eq Movie.count
  #fail "Unimplemented"
end
