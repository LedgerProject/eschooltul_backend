# README

## Development

Start server: `rails server`

or if you want webpack with hot reload:

`heroku local -f Procfile.dev`

### Setup

- Ask first for a master key: https://guides.rubyonrails.org/security.html#custom-credentials
- `bundle install`
- `yarn install`
- `rails db:setup`

#### Changing Secrets

- Using Atom: `EDITOR='atom --wait' bin/rails credentials:edit`
- Using VSCode: `EDITOR='code --wait' bin/rails credentials:edit`
