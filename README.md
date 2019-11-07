### Clone the repository

```sh
$ git clone https://github.com/abdsofia/customers-provider.git
$ cd customers-provider
```
### Install and configure system dependencies


In order to run the project, you'll need:

* ruby 2.5.5 
* Rails 6.0.0
* PostgreSQL
* Redis
* Sidekiq
* Bundler
* foreman

### Run bundler to install gems:

```sh
$ bundle install
```

### Set up your local environment

```sh
$ cp .env.example .env
$ cp config/database.yml.example config/database.yml
# => Make sure to set PostgreSQL related environment variables in `.env`
```

### Database Setup


```sh
$ rails db:migrate
```

### Run the app

Instead of running `sidekiq`, `redis-server` and `rails s` separately, Procfile-based simplification is used. To start the web app, simply run:

```sh
$ foreman start -f Procfile
```