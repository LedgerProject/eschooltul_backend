# Eschooltul

[![CI](https://github.com/LedgerProject/eschooltul_backend/actions/workflows/main.yml/badge.svg)](https://github.com/LedgerProject/eschooltul_backend/actions/workflows/main.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)


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

## Deploy

The app is hosted at DigitalOcean using Dokku.

The deploy is done via Github Actions on the main branch, but you can deploy manually:

- `git remote add eschooltul dokku@droplet-ip:eschooltul`
- `git push eschooltul main:master`
- `ssh root@droplet-ip`
- `dokku run eschooltul rails db:migrate`
