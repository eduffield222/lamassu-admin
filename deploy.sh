#!/usr/bin/env bash

git remote | grep heroku
if [ $? -ne 0 ]; then
  echo "Creating Heroku application..."
  heroku apps:create
fi

echo "Creating Postgres addon..."
db=$(heroku addons:add heroku-postgresql:dev | awk '/Attached as ([A-Z]+)/ { print $3 }')
echo "$db created"

echo "Waiting for Postgres to become active..."
heroku pg:wait

echo "Promoting $db as primary"
heroku pg:promote "$db"

echo "Seeding Postgres..."
heroku pg:psql < database/lamassu.sql

echo "Deploying..."
git push heroku newnew:master