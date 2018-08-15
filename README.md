# Anagram Search

## Description
This application provides fast searches for anagrams. Anagrams are ingested when the application loads and provides the following endpoints.
Three endpoints currently exist:
 1. POST [`/words.json`](#words)
 2. GET [`/anagrams/:word.json`](#anagrams)
 3. DELETE [`/words/:word.json`](#words)
 4. DELETE [`/words.json`](#words)
 5. GET [`/stats.json`](#stats)


These endpoints are documented below with example usage.

## Notes
Initially, I wrote this up using Rails API but I started to think that since the project specified building an API allowing for **fast** searches, Rails most likely added unnecessary overhead. I had some time yesterday, so I went back and wrote up two more versions of the API, one with Ruby/Sinatra and another in Go (I've just recently started playing around with Go). I did some benchmark testing using Apache ab and, to no surprise, the Go version is the fastest. The Go version was also substantially faster when it came to ingesting the dictionary file.

To run tests against each server, I ran the server for the corresponding version and executed:
```bash
$ ab -k -c 10 -n 10000 -v 4 $MY_REQUEST http://localhost:3000/anagrams/read.json
# Rails required http://0.0.0.0:3000/anagrams/read.json for some reason
```
This corresponded to 10 concurrent processes serving a total of 10000 requests.
The interesting stats for each API are what follows below. It's noteworthy that Rails was the slowest in terms of time per request, number of requests per second and was the only API that had any failed requests. My guess is that this is due to Apache ab server requests faster than it could handle.
I was able to drastically improve time per request for both Rails and Sinatra by disabling the stdout logging. In the end, the Go API is the clear winner when it comes to fast concurrent searches.
#### GO:
```
Concurrency Level:      10
Time taken for tests:   2.770 seconds
Complete requests:      10000
Failed requests:        0
Requests per second:    3609.81 [#/sec] (mean)
Time per request:       2.770 [ms] (mean)
Time per request:       0.277 [ms] (mean, across all concurrent requests)
```
***
#### Ruby On Rails API
```
Concurrency Level:      10
Time taken for tests:   19.992 seconds
Complete requests:      10000
Failed requests:        1453
Requests per second:    500.21 [#/sec] (mean)
Time per request:       19.992 [ms] (mean)
Time per request:       1.999 [ms] (mean, across all concurrent requests)
```
***
#### Ruby w/ Sinatra
```
Concurrency Level:      10
Time taken for tests:   6.834 seconds
Complete requests:      10000
Failed requests:        0
Requests per second:    1463.37 [#/sec] (mean)
Time per request:       6.834 [ms] (mean)
Time per request:       0.683 [ms] (mean, across all concurrent requests)
```

Full Benchmark Stats:
[Benchmark Rails API](./ruby_rails_benchmark.md)
[Benchmark Ruby Sinatra](./ruby_sinatra_benchmark.md)
[Benchmark Go](./go_benchmark.md)

## To Run Locally
Execute:
```bash
  $ git clone https://github.com/scottberke/anagram-search.git
  $ bundle
  $ rails s
```

To run tests:
```bash
$ bundle exec rspec spec/
```

## Endpoints

### Anagrams
#### GET /anagrams/:words.json
Used to get anagrams for a word. Consumes a word and returns JSON of matching anagrams.

##### Request
```bash
curl -X GET \
  http://localhost:3000/anagrams/read.json \
```
##### Response 200 OK
```json
{
    "anagrams": [
        "ared",
        "daer",
        "dare",
        "dear"
    ]
}
```

### Words
#### POST /words.json
Use to add words to the anagrams dictionary. Takes a JSON array of English-language words.

##### Request
```bash
curl -X POST \
  http://localhost:3000/words.json \
  -H 'Content-Type: application/json' \
  -d '{ "words": ["read", "dear", "dare"] }'
```
##### Response 201 Created
```json

```

#### DELETE /words.json
Use to delete all contents in the dictionary.

##### Request
```bash
curl -X DELETE \
  http://localhost:3000/words.json \
```
##### Response 204 No Content
```json

```

#### DELETE /words/:word.json
Use to delete a single word from the dictionary.

##### Request
```bash
curl -X DELETE \
  http://localhost:3000/words/read.json \
```
##### Response 204 No Content
```json

```

### Stats
#### GET /stats.json
Used to obtain stats for the words in the dictionary.

##### Request
```bash
curl -X GET \
  http://localhost:8080/stats.json \
```
##### Response 200 OK
```json
{
    "stats": {
        "min": 1,
        "max": 24,
        "median": 0,
        "average": 9.56,
        "words_count": 235886
    }
}
```
