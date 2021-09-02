# Rails Stimulus Reflex + Vite Starter Template

This application template is a starting point for building modern, reactive Ruby on Rails applications
powered by [Stimulus Reflex](https://docs.stimulusreflex.com/), with [Turbo](https://github.com/hotwired/turbo-rails) and [WindiCSS](https://windicss.org/).

In addition to a modern, StimulusReflex-powered user experience, we use [Vite](https://vite-ruby.netlify.app/) instead of Webpacker so we can spend less time fighting with our build tools and more time delivering value to our users.

## Usage
To get started, create a new Ruby on Rails application, passing in this template with the `-m` option:
```
rails new your_new_application -m https://raw.githubusercontent.com/davidcolby/vite_starter_template//main/template.rb
```

To make this template the default for new Rails applications you create, create a .railsrc file with `touch ~/.railsrc` and fill it in with:
```
-m https://raw.githubusercontent.com/davidcolby/vite_starter_template//main/template.rb
```

Once this file exists with the `-m` option provided, you can simply run `rails new your_new_application` and this template will be used automatically.

## What's included?
* Ruby on Rails
* Stimulus
* StimulusReflex
* Turbo (Turbo Drive and Turbo Frames work well with StimulusReflex, you won't need Turbo Streams with SR)
* WindiCSS
* Vite

Common Rails gems like Devise are NOT included, intentionally. My goal is to provide an unopinionated base application that can be built upon freely.

Looking for something with more features? There are great options out there for more opinionated and full-featured Rails starters, including [Jumpstart](https://github.com/excid3/jumpstart) and [Jumpstart Vite](https://github.com/ElMassimo/jumpstart-vite), which provided inspiration for me while putting this simpler starter together.

## Contributing
Issues and PRs are welcome.


