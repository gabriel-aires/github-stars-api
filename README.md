# Github Stars API

This is a simple API that interacts with Github to fetch data about user repositories

## Tools used for this project

- SQLite
- Sucker Punch
- HTTParty
- Webmock

## Usage

```
bundle
rails db:migrate
rails server
```

## Endpoints

- POST /users/:login (adds user and fetches repository information in the background)
- GET /users/:login/repositories (list repositories for a given user)

## Testing

```
rspec
```
