*Work in progress*

# Unnamed Newsletter

This app scrapes articles from my favourite publications, and sends them directly to your e-reader every Friday.


## Why?

I like reading long articles on my Kindle. There are services - like the Send To Kindle chrome extension - which you can use to send particular articles to your Kindle. But you have to manually find the articles and click the extension.

Unnamed Newsletter automatically sends the best articles on the internet to your e-reader in time for the weekend.

## Tech

This is a Sinatra app with a Postgres database. It uses Nokogiri to scrape some pre-defined publications for new articles, saves them to the database, and sends an email newsletter - using the Pony gem - with 3 random articles to all users.

## Todo
- Settle on a stable way of saving an article's raw HTML.
- Schedule the services that scrape articles and send the newsletter as Cron jobs.
- Allow users to login and sign up for the newsletter.
- Deploy to Heroku.
