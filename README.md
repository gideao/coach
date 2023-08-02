# Coach [Under Development] [![Build Status](https://travis-ci.org/gideao/coach.svg?branch=master)](https://travis-ci.org/gideao/coach)

This is a tool to help automate common tasks such as compiling, testing and submitting files when solving programming challenges on the URI Online Judge platform.

This project's goals are listed below.

- Compile your code file based on its extension
- Test your solution against the test cases
- Upload solution's file

## Status

Current supported platforms:

- URI Online Judge's [traker, tests]

Languages supported:

- C with GCC

Todo:

- Add program templates for others languages [Ruby, Java, JavaScript, C++, Python, Go, C#, Kotlin]
- Add compilation support for other languages [Java, C++, Kotlin, Scala, C#, Go]

## Installation

Use gem command to install:

    $ gem install coach
    
Or clone this repository and manually install:

    $ bundle exec rake install

## Usage

Create new solution's file from template.

    couch new FILE # or
    couch n FILE

Mark a problem as done.

    couch done -p PROBLEM # or
    couch d -p PROBLEM

Skip a problem

    couch skip -p PROBLEM # or
    couch s -p PROBLEM

Test your code against test cases

    couch test mycode.c -p PROBLEM # or
    couch t mycode.c -p PROBLEM

Your can use base name as problem id 

    couch test 1010.c

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/coach.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
