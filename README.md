# CurationConcerns

[![Version](https://badge.fury.io/rb/curation_concerns.png)](http://badge.fury.io/rb/curation_concerns)
[![Build Status](https://travis-ci.org/projecthydra-labs/curation_concerns.svg?branch=master)](https://travis-ci.org/projecthydra-labs/curation_concerns)
[![Coverage Status](https://coveralls.io/repos/projecthydra-labs/curation_concerns/badge.svg?branch=master)](https://coveralls.io/r/projecthydra-labs/curation_concerns?branch=master)
[![Code Climate](https://codeclimate.com/github/projecthydra-labs/curation_concerns/badges/gpa.svg)](https://codeclimate.com/github/projecthydra-labs/curation_concerns)
[![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE.txt)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/gems/curation_concerns)
[![Stories in Ready](https://badge.waffle.io/projecthydra-labs/sufia-core.png?source=projecthydra-labs%2Fcuration_concerns&label=ready&title=Ready)](https://waffle.io/projecthydra-labs/sufia-core?source=projecthydra-labs%2Fcuration_concerns)

A Hydra-based Rails Engine that extends an application, adding the ability to Create, Read, Update and Destroy (CRUD) objects (based on [Hydra::Works](http://github.com/projecthydra-labs/hydra-works)) and providing a generator for defining object types with custom workflows, views, access controls, etc.

## Installation

Checkout the dependencies for [curation_concerns-models](https://github.com/projecthydra-labs/curation_concerns/tree/master/curation_concerns-models#dependencies), which is installed as part of curation_concerns.

Add this line to your application's Gemfile:

    gem 'curation_concerns'

And then execute:

    $ bundle install

Then run the install generator.  You will be prompted if you want to overwrite the default `app/controllers/catalog_controller.rb`, to which you should type `Y` (yes). If you don't want to be prompted on overwrite, you may run the generator with the `-f` (force) option.

    $ rails generate curation_concerns:install
    $ rake db:migrate

## Usage

### Generator

To generate a new object type, use the `curation_concerns:work` Rails generator.  Follow the usage instructions provided on the command line when you run:

    $ rails generate curation_concerns:work

### Virus Detection

To turn on virus detection, install clamav on your system and add the `clamav` gem to your Gemfile

    gem 'clamav'

## Testing

If you are modifying the curation_concerns gem and want to run the test suite, follow these steps to set up the test environment.

    $ rake ci
    
Or you can do all the steps manually:

    $ solr_wrapper -p 8985 -d solr/config/ --collection_name hydra-test
    
    # in another window
    $ fcrepo_wrapper -p 8986 --no-jms
    
    # in another window
    $ rake engine_cart:generate
    $ rake curation_concerns:spec
