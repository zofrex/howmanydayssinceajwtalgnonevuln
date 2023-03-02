## Help! The counter needs resetting!

You can [ping me on Mastodon](https://hachyderm.io/@zofrex) (or [Twitter](https://twitter.com/zofrex)) to update it, or, if you want, make a Pull Request yourself to add the new incident to [the list](data/vulns.yml).

## Adding incidents

Add a new entry to [data/vulns.yml](data/vulns.yml). Each entry should have a "date" field (in the format YYYY-MM-DD) and a "description" field, which can contain HTML – and should contain a link to a write-up.

Incident criteria:

* Sourced: There must be some third-party documentation that the vuln existed.
* Dated: For consistency, we are using the disclosure date as the vuln date, as this is the only date we can definitively narrow down for all issues.
* Vulnerability: It must be an alg=none vuln or morally equivalent (e.g. not checking signatures at all).

## Contributing

If a new alg=none vuln has come out then you can contribute either by [letting me know](https://twitter.com/zofrex) or by making a PR to add the incident. Or both. I'm more likely to see a Tweet than an email, so feel free to ping me on Twitter too.

You can also contribute by adding historical incidents to [the list](data/vulns.yml). Once that is more fleshed out I intend to produce a page listing all historical incidents, as well as keeping track of a "high score" stat of the longest run there has been between incidents.

It's really easy to add new entries to that list, and it'd be a big help, so if you know of any incidents not listed here please add them!

## Setting up local development

Please note it is not a pre-requisite for contributing incidents to this repo to get the website building locally. When you make a PR a preview of the site with your changes will automatically be generated for you. These instructions are here for my benefit as much as anyone's.

### Requirements

* Ruby
* Bundler

Install the dependencies with:

```
bundle install
```

### Running

```
bundle exec middleman serve
```
