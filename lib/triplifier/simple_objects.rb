module Triplifier

	class URI

		def initialize(uri)
			@uri = uri
		end

		def to_s
			"<#{@uri}>"
		end

		def self.is_uri? (uri)
			uri.kind_of?(Symbol) || uri.kind_of?(URI)
		end

	end

	class SimpleNode

		include Triplifier::Node
		attr_accessor :parent

		def self.eval(&block)
			instance_eval(&block)
		end

		def initialize(parent)
			@parent = parent
		end

	end

	class Graph

		def initialize
			@prefixes = {
				:rdf  => Triplifier::URI.new('http://www.w3.org/1999/02/22-rdf-syntax-ns#'),
				:rdfs => Triplifier::URI.new('http://www.w3.org/2000/01/rdf-schema#'),
				:owl  => Triplifier::URI.new('http://www.w3.org/2002/07/owl#'),
				:xsd  => Triplifier::URI.new('http://www.w3.org/2001/XMLSchema#')
			}
			@nodes = {}
		end

		def <<(node)
			if node.kind_of? Array
				node.each { |n| self << n}
				return
			end
			node.class.prefixes.each do |ns, uri|
				#TODO: validation
				@prefixes[ns] = uri
			end
			@nodes[node.resource] = node
		end

		def to_turtle
			ttl = ""
			@prefixes.each do |ns, uri|
				ttl << "@prefix #{ns}: #{uri} . \n"
			end
			@nodes.each do |resource, node|
				ttl << node.to_turtle
			end
			ttl
		end

	end

end