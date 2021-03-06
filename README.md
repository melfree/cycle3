# Cycle 3 Team 8

Taken from an existing example of a simple Comments app, to become ShoppingBlocks app. Setup directions follow below.

## Dependencies

You must have redis installed and running on the default port:6379 (or configure it in config/redis/cable.yml).

### Installing Redis
##### On Linux
* `wget http://download.redis.io/redis-stable.tar.gz`
* `tar xvzf redis-stable.tar.gz`
* `cd redis-stable`
* `make`
* `make install`

##### On Mac
* `brew install redis`

###### Note: You must have Ruby 2.2.2 installed in order to use redis

## Starting the servers

1. Run `./bin/setup`
2. Open up a separate terminal and run: `./bin/rails server`
3. One more terminal to run redis server: `redis-server`
4. Visit `http://localhost:3000`

The buyers/sellers feeds are real-time. Open two browsers with separate cookie spaces (like a regular session and an incognito session) to confirm this.

For updates run:

1. rake db:drop
2. rake db:migrate
3. rake db:setup
4. rake assets:precompile
