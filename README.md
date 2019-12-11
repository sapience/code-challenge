## Table of contents

- [How big datastorage we need](#how-big-datastorage-we-need)
- [Algorithm for getting a short link](#algorithm-for-getting-a-short-link)
- [Database selection](#database-selection)
- [Ruby framework selection](#ruby-framework-selection)
- [Using background jobs](#using-background-jobs)
- [How do i find a country by ip](#how-do-i-find-a-country-by-ip)
- [What should we do if the data no longer fits in RAM](#what-should-we-do-if-the-data-no-longer-fits-in-ram)
- [How did I test performance and what results did I get](#how-did-i-test-performance-and-what-results-did-i-get)
- [What did not go well?](#what-did-not-go-well)
- [If i had more time to work on this](#if-i-had-more-time-to-work-on-this)
- [How to install and run](#how-to-install-and-run)

### How big datastorage we need

We want to serve 10_000_000 users per day. Suppose 10_000_000 hits per day with short link for redirect and additional 1% (100_000 users per day) comes to create short links.\
Lets calculate how much storage we need.\
Short link takes till 7 bytes, long link takes, lets say, 1000 bytes. So in the month this data will be 1 KB \* 100_000 \* 30 = 3 GB\
We need to save ip address for each uniq user per link. Ipv4 takes till 14 bytes as a string representation. Let it be the most difficult situation when each user is unique. So in a day we have to save 14 \* 10_000_000 = 14 MB, in month - 14 \* 30 = 420 MB.\
So total in the month we need 3 + 0.5 = 3.5 GB\
In a year it will be 42 GB.\
**If we take the dedicated server with 128 GB of RAM, then we can store all our data almost for 3 years completely in RAM.**\
What to to if we want to store all the data more than 3 years is described below in special section.

### Algorithm for getting a short link

I chose a short link generation algorithm that is independent of inputed long links.\
It can be done by using bijective function on unic ids. It can be base62 encoding. Unic ID we can get by incrementing some integer key in database `uniq_id = redis.incr('uniq_id')`\
Then we do base62 encoding ([A-Z, a-z, 0-9]) of the ID. In 7 bytes we can get over 3.5 trillion short links.

### Database selection

Since our data is fully placed in RAM, the natural choice is a fast no only sql storage that is completely in RAM - **Redis**.\
Since we don&apos;t need complex statistical queries with filtering and conditions, we can only stay on Redis.\
If in the future we need such statistics, then we can additionally use the relational database (for example **PostgreSQL**).\ The data can be transferred from Redis to Postgres periodically by cron jobs (for example once a day).\

### Ruby framework selection

Probably for tasks like this the ruby is not the best choice. But if we must use it, then we has to pick some fast and lightweight framework. I chose **Sinatra**.

### Using background jobs

The actions that user interact with should perform well and not have any delays. In our case it is a generation of the short link and redirections. So for redirections we have to unshorten link and immediately redirect a user. The calculation and storing statistics should be run in separate process.\
For background jobs i chose the **Sidekiq**.

### How do i find a country by ip

I use gem [maxminddb](https://github.com/yhirose/maxminddb) and [free GeoIP2 database](https://dev.maxmind.com/geoip/geoip2/downloadable/)\
Country determination by ip occurs in separately background job.

### What should we do if the data no longer fits in RAM

The possible options:
- Add more RAM :) if it possible
- Build Redis cluster with sharding

### How did I test performance and what results did I get

I used very simple HTTP load generator [hey](https://github.com/rakyll/hey)\
I used it that way `hey -n 20000 http://localhost:4567/casdfg`\
Despite the fact that I requested the same address, all the operations performed in this case were generated such load, as if different addresses were requested for each hit. Therefore, with a certain assumption, we can assume that such a test is relevant.

##### Test results

>➜  ~ hey -n 20000 http://localhost:4567/c

>Summary:
Total: 134.3142 secs
Requests/sec: 148.9046

>Status code distribution:
 [200] 20000 responses

### What did not go well?

I did not have experience with the react, so I spent a lot of time on the front-end part. And I don&apos;t really like the look of the resulting interface.

### If i had more time to work on this

- Would add more checks for incorrect function parameters.
- Would write more tests.
- Write comments in code
- Would make experiments with settings and adapters of Redis, settings of Thin server (mayby try to change it to Puma). Want to make system faster. Would like to understand where the bottleneck is.
- Would make the better UI.

### How to install and run

- Install and run [Redis](https://redis.io/download)
- Clone the repository.
- Make sure the right host and port for Redis instance are in files:
  - /config/initializers/01_db.rb
  - /config/initializers/02_sidekiq.rb
- In project folder run `bundle install`
- Go to client folder `cd client` and run `npm install`
- From project folder run `bin/sidekiq`
- From project folder run `bin/server`
- Go to client folder `cd client` and run `npm start`
