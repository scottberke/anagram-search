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

## Assumptions


## To Run Locally
Execute:
```bash
  $ git clone https://github.com/scottberke/anagram-search.git
  $ bundle
  $ rails s
```

To see available flags:
```bash
$ ./go-password-hasher -h
Usage of ./go-password-hasher:
  -delay int
    	number of seconds to delay hash response (default 5)
  -port int
    	a port to start the server on (default 8080)
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
