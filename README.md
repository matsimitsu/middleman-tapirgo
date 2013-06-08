Middleman TapirGo - Sync generated content from [middleman](http://middlemanapp.com/) to [TapirGo](http://tapirgo.com)


# QUICK START

## Step 1

Edit `Gemfile`, and add:

    gem "middleman-tapirgo"

Then run:

    bundle install

## Step 2 -  setup

**These settings are required.**

Edit `config.rb`, and add:

    activate :tapirgo do |tapir|
      tapir.api_key = "[Your tapirgo api key]"
    end

## Step 3

Run middleman build, after compiling your site, your content will be
pushed to TapirGo

    middleman build

## Thanks

Based on the middleman-deploy gem by
[Tom Vaughan](https://github.com/tvaughan/middleman-deploy).
