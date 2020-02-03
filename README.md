# Rails Test

This application is a demo of Ruby on Rails skills.

It interacts with an API called `Widgets` and allows the user to:
- See a searchable list of Visible Widgets
- Clicking on the user reference on a widget it navigates to a view which presents that Users information, along with a list of that Users Widgets.
- Login/Logout/Register/Reset Password via Modal
- Once logged in, the User is able to navigate to a view of their Widgets create/delete/edit their widgets.

## Dependencies

- `ruby 2.6.5`
- `rails 5.2.3`
- `redis` # it's also used to store data needed for application functioning, no database is required

## Getting started

```
$ bundle install
$ rails dev:cache # needed to start caching in development
$ rails s
```

## Deployment

It can be easily deployed to Heroku:
```
$ heroku create <heroku_app_name>
$ git push heroku
$ heroku config:set RAILS_MASTER_KEY=<master-key>
```
Add a Redis add-on, like `Heroku Redis`

## Demo version

There is a demo version deployed at https://we-rails-test.herokuapp.com/
