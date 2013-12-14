module Triplifier

	module Node

		class << self
			def included(base)
				base.extend(ClassMethods)
			end
		end

		def uri(string)
			self.class.uri(string)
		end

		def to_turtle
			subject = resource
			ttl = ""
			predicates.each do |predicate|
				objects(predicate).each do |object|
					turtlified, extras = turtlify(object)
					pred = predicate.to_s.split('@')
					if pred.length == 2
						predicate, suffix = pred
						suffix = "@#{suffix}"
					else
						suffix = ''
					end
					ttl += "#{subject} #{predicate} #{turtlified}#{suffix} .\n" unless turtlified.nil?
					if !extras.nil? && extras.kind_of?(SimpleNode)
						ttl += extras.to_turtle
					end
				end
			end
			self.class.defines.each do |klass|
				object = klass.new(self)
				ttl += object.to_turtle
			end
			ttl
		end

		def resource
			res = self.class.resource
			if res.kind_of? Proc
				res = instance_eval(&res)
			end
			res = Triplifier::URI.new(res) unless Triplifier::URI.is_uri?(res)
			res
		end

		def predicates
			self.class.subjects.keys
		end

		def objects(predicate = nil)
			objs = []
			if predicate.nil?
				predicates.each do |pred|
					objs.concat objects(pred)
				end
			else
				self.class.subjects[predicate].each do |obj|
					objs.concat(eval(obj))
				end
			end
			objs
		end

		def eval(object)
			if object.kind_of? Proc
				object = instance_eval(&object)
			elsif object.kind_of? Class
				object = object.new(self)
			end
			object = [object] unless object.kind_of? Array
			object
		end

		def turtlify(object)
			if URI.is_uri? object
				return [object.to_s]
			elsif object.kind_of? Numeric
				return [object.to_s]
			elsif object.kind_of? String
				object = object.gsub("\r","\n").gsub('\\','\\\\\\\\').gsub('"','\\"')
				return nil if object.length == 0
				return ["\"#{object}\""] if object.scan("\n").length == 0
				return ["\"\"\"#{object}\"\"\""]
			elsif object.kind_of?(TrueClass) || object.kind_of?(FalseClass)
				["'#{object}'^^xsd:boolean"]
			elsif object.kind_of? Date
				["\"#{object.iso8601}\"^^xsd:date"]
			elsif object.respond_to? :resource
				[object.resource, object]
			end

		end

		module ClassMethods

			attr_reader :subjects, :prefixes

			def resource(string = nil, &block)
				return @resource if string.nil? && !block_given?
				@resource = string.nil? ? block : string
			end

			def subject(predicate, object = nil, &block)
				@subjects = {} if @subjects.nil?
				@subjects[predicate] = [] if @subjects[predicate].nil?
				@subjects[predicate] << (object.nil? ? block : object)
			end

			def prefix(ns, uri)
				@prefixes = {} if @prefixes.nil?
				@prefixes[ns] = uri.kind_of?(URI) ? uri : Triplifier::URI.new(uri)
			end

			def node(&block)
				klass = Class.new(Triplifier::SimpleNode)
				klass.eval(&block)
				klass
			end

			def defines(&block)
				@defines = [] if @defines.nil?
				return @defines unless block_given?
				klass = Class.new(Triplifier::SimpleNode)
				klass.eval(&block)
				@defines << klass
				klass
			end

			def uri(string)
				Triplifier::URI.new string
			end

		end

	end
	
end