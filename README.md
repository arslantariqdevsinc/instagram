# README
*** INSTAGRAM CLONE ***

Prerequisites:
    1. Install Ruby. Preferably version 2.6.6
    2. Install Rails v6.0.0
    3. Yarn and Node

How to run:
    1. clone the repository, https://github.com/arslantariqdevsinc/instagram.git, (you can find relevant information about cloning here: https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository

    2. Run bundle install to install gems. bundle install

    3. Installing Hotwire.
        The gems for turbo-rails and stimulus-rails are already in GEMFILE.
        3.1 Run rails install:turbo and rails install:stimulus to install turbo and stimulus respectively.

Database:
    The project uses PostgreSQL. If you want to use any other database. Sqlite for example, you would need to configure it yourself.
    You can find the configurations easily on the internet.

    1. Create a PostgreSQL database for local development. Follow this guide to create a database: https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-18-04

    The Database name is instagramc_ suffixed by three of the environments, ["development", "production", "test"]. For example,
    database for development is instagramc_development. You can confirm and configure this in database.yml file if you choose to change the name of database.

    2. Run the command: rails db:setup

Sidekiq:
    The project uses Sidekiq for background jobs except for the development enviroment where it uses default async adapter. Should you choose to use Sidekiq for development. Set config.active_job.queue_adapter = :Sidekiq

    Note that for deployment, you must use Sidekiq or other background task runner. Check Deployment section for details.

Deployment:
    1. You would ned to configure Sidekiq and Redis. The Rest is standard deployment procedure.








