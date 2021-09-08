# Phawn

# Installation

```bash
bundle install
bundle exec rackup

```

# Usage

```bash
curl -F 'data=@samples/headerfull.csv' localhost:9292/numbers -F 'headers=true' -F 'column=sms_phone'
curl -F 'data=@samples/headerless.csv' localhost:9292/numbers -F 'headers=false' -F 'column=1'
```