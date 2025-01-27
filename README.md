# Delight

Delight's technical test, which description can be found in here : [Delight](https://app-delight.notion.site/Stage-Back-End-API-Spotify-1367274055b680c39ff5c90a42d8083f)

## First thing first

Retrieve your own id and secret from the Spotify Api as mentionned in [this link](https://developer.spotify.com/documentation/web-api/tutorials/getting-started)

## Option 1 : Docker

### Setup
Make sure you got Docker installed on your computer.
Create a file named **env.list** at the root of the project, open it and put your id and secret inside :
```
CLIENT_ID=my-own-client-id-without-quotes
CLIENT_SECRET=my-own-secret-id-without-quotes
```

### RUN

Then run the following command in your terminal :
``` sh
docker build -t delight . && docker run -it --env-file env.list --rm delight
```

## Option 2 : Local running

### Setup

To get the program running on your own environment, first [install Elixir](https://elixir-lang.org/install.html#by-operating-system).

Then run the following command :
``` shell
mix deps.get
```
to install the project dependencies.

Compile with :
``` shell
mix compile
```

And start the resulting executable with :
``` shell
iex -S mix  
```

Once inside the elixir terminal, you can type 
```
Delight.main
```
to test all the required elements, or any of the following to test them one by one :
```
Delight.list_albums
Delight.list_albums_without_singles
Delight.list_albums_sorted_by_date
```

## Eventually...

Exit with ctrl+C, twice.
Thanks for having a look :)