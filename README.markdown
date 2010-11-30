# ydd - Yaml DB Dumber

A fork of the awesome [yaml_db](http://github.com/ludicast/yaml_db).

## Installation

This plugin can now be installed as a gem via 

    gem install ydd


## Usage

    ydd dump where-to-dump rails-app-root
    ydd dump where-to-dump # Default to pwd for rails app
    ydd dump where-to-dump rails-app-root --force # override the dump folder check
    ydd dump where-to-dump rails-app-root --env=staging # change env to dump
    
All are applicable with dump and load above as the command.

Note that this creates a `schema.rb` and a `data.yml` in the data dump directory.

## Credits

This gem is maintained by Darcy Laycock and Dirk Kelly.

Created by Orion Henry and Adam Wiggins.  Major updates by Ricardo Chimal, Jr.

Patches contributed by Michael Irwin, Tom Locke, and Tim Galeckas.

Send questions, feedback, or patches to the Heroku mailing list: http://groups.google.com/group/heroku

