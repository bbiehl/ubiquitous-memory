### Create the new application.
I like to start without a boilerplate test suite because we'll add RSpec later. 
```
$ rails new MYAPP -T
$ cd MYAPP
$ rails s
```
At this point we should see the 'Yay, you're on Rails' page.

### Set up dependencies
```
$ vim Gemfile
```
* Set up dependencies for `Active Admin` and the ability to change image size when we use `Active Storage`.
```ruby
# for activeadmin
gem 'activeadmin'
gem 'devise'
# mini_magic to transform images
gem 'mini_magick'
```
* Move the boilerplate sqlite3 to dev/test.
* Assign production postgresql so we can deploy to Heroku.
```ruby
group :production do
  gem 'pg'
end
```
* I also threw in some dependencies for `RSpec/Capybara/Selenium` to set up test automation down the road. I don't plan on getting into that in this tutorial though.

#### Make the `Gemfile` look something like this.
> I comment out `spring` in dev because it has been causing my active_admin installations to hang. I don't know why this is.
```ruby
source 'https://rubygems.org'
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 5.2.3'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

# for activeadmin
gem 'activeadmin'
gem 'devise'
# mini_magic to transform images
gem 'mini_magick'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3'
  # The RSpec testing framework
  gem 'rspec-rails'
  # Capybara, the library that lets us interact with the browser using Ruby
  gem 'capybara'
  # The library that helps Capybara interact with the browser
  gem 'webdrivers'
  # Do we still need this?
  # gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'pg'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

```
Then run `bundle`
```
$ bundle
```
### Set up RSpec
> This is good to have for later if you want it.
```
$ rails g rspec:install
```
Run RSpec to make sure it works.
```
$ rspec
```
### Create the `home` page
```
$ rails g controller static_pages home
```
Set the root.
```
$ vim config/routes.rb
```
```ruby
Rails.application.routes.draw do
  root 'static_pages#home'
end
```
Verify we can see the boilerplate page
```
$ rails s
```
### Install Active Admin 
> This command had been hanging, so I commented out `Spring` dependencies in the `Gemfile`. This worked but I don't know why.
```
$ rails g active_admin:install
$ rails db:migrate db:seed
```
Now make sure we can navigate to the `/admin` page.
```
$ rails s
```
### Generate our model.
```
$ rails g model beer name:string abv:string ibu:string description:text
```
### Add our newly generated model as an Active Admin resource
```
$ rails g active_admin:resource Beer
```
### Update permitted params.
```
$ vim app/admin/beers.rb
```
It should look something like this. 
> I removed the boilerplate commented out information.
```ruby
ActiveAdmin.register Beer do
  permit_params :name, :abv, :ibu, :description, :image

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :name
      f.input :abv
      f.input :ibu
      f.input :description
      f.input :image, as: :file
      f.actions
    end
  end

  show do
    attributes_table do
      row :name
      row :abv
      row :ibu
      row :description
      row :image do |ad|
        image_tag url_for(ad.image)
      end
      active_admin_comments
    end
  end
end

```
### Enable the page to display content.
```
$ vim app/views/static_pages/home.html.erb
```
The view file should look something like this. All we're trying to do is verify we can view information in the database.
```html
<h1>StaticPages#home</h1>
<p>Find me in app/views/static_pages/home.html.erb</p>

<% @beers = Beer.all %>
<% @beers.each do |beer| %>
  <h3><%= beer.name %></h3>
  <h4><%= beer.description %></h4>
  <p>ABV: <%= beer.abv %></p>
  <p>IBU: <%= beer.ibu %></p>
  <p><%= image_tag beer.image.variant(resize: "100x50") %></p>
<% end %>
```
### Verify we can view content.
```
$ rails s
```
Derp! No content.
Navigate to `/admin` and add some beers.
Navigate back to `/`
Now we can see beers.
