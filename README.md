# Triplifier

Let's have class Person having first and last name, website and email and few friends.
And we want to convert this class to rdf turtle:


```ruby
class Person
	include Triplifier::Node

	prefix :foaf, 'http://xmlns.com/foaf/0.1'
	resource { "#{@website}#me" }
	subject :'foaf:firstName' do @first_name end
	subject :'foaf:lastName'  do @last_name end
	subject :'foaf:mbox' do @email end
	subject :'foaf:weblog' do uri(@blog) end
	subject :'foaf:knows' do @friends end

end

graph = Triplifier::Graph.new
graph << some_person_instance

puts graph.to_turtle

```

## Installation

Add this line to your application's Gemfile:

    gem 'triplifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install triplifier

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
