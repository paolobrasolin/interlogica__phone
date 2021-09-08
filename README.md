# Phawn

This is an API server to validate South African phone numbers.

# Installation

You will need to install Ruby `2.7.0`; then,

```bash
bundle install
bundle exec rackup
```

and the server will be up and running at `localhost:9292`.

# Endpoints

The API has two endpoints which accept `POST`ed form data:

* `/number` processes a single phone number and requires a single parameter:
  * `number`: the phone number

* `/numbers` processes a CSV of phone numbers and requires three parameters:
  * `data`: a CSV file
  * `headers`: whether `data` has headers (either `true` or `false`)
  * `column`: the name of the column to read the numbers from (a header if `headers` is `true` and a zero-based index otherwise)

The responses will contain the original numbers, their validity, a processed version and the pplied transformations.

# Sample usage

A few examples of `/number` usage:

```bash
# A valid number
curl localhost:9292/number -F 'data=27123456789'
# => {"status":"success","data":{"origin":"27123456789","output":"27123456789","status":"VALID","change":[]}}

# A short number
curl localhost:9292/number -F 'data=123456789'
# => {"status":"success","data":{"origin":"123456789","output":"27123456789","status":"FIXED","change":["PREFIX"]}}

# A full number
curl localhost:9292/number -F 'data=+27 12 345 6789'
# => {"status":"success","data":{"origin":"+27 12 345 6789","output":"27123456789","status":"FIXED","change":["WHITESPACE","PREFIX"]}}

# An invalid number
curl localhost:9292/number -F 'data=FOOBAR'
# => {"status":"success","data":{"origin":"FOOBAR","output":null,"status":"BOGUS","change":null}}
```

A few examples of `/numbers` usage:

```bash
# A CSV with headers
curl localhost:9292/numbers -F 'data=@samples/headerfull.csv' -F 'headers=true' -F 'column=sms_phone'
# => {"status":"success","data":[...]}

# A CSV without headers
curl localhost:9292/numbers -F 'data=@samples/headerless.csv' -F 'headers=false' -F 'column=1'
# => {"status":"success","data":[...]}
```

# Running tests

This project uses `minitest`:

```bash
# To run the whole suite:
ruby -Ilib:test test/test_phawn.rb

# To run a specific test:
ruby -Ilib:test test/phawn/test_XXX.rb
```
