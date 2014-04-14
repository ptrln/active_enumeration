require 'active_support/inflector'

module BetterEnum
  class Base

    def self.find(id)
      id = id.to_i
      @instances ||= {}
      unless @instances[id] || !@better_enum_values[id]
        @instances[id] = self.new *@better_enum_values[id]
      end
      @instances[id]
    end

    def self.all
      @better_enum_values.keys.map { |id| self.find(id) }
    end

    def self.count
      @better_enum_values.count
    end

    def self.to_a
      all.map { |e| [e.to_s, e.instance_variable_get("@better_enum_id")] }
    end

    def symbol
      self.instance_variable_get("@symbol")
    end

    protected

    def self.attr_reader(*attributes)
      super
      @better_enum_attributes ||= []
      @better_enum_attributes.concat(attributes.map(&:to_sym))
    end

    def initialize(*attributes)
      key_index = self.class.better_enum_index_location
      self.instance_variable_set("@better_enum_id", attributes[key_index].to_i)

      self.class.better_enum_attributes.each_with_index do |attr_name, index|
        self.instance_variable_set("@#{attr_name}", attributes[index])
      end
    end

    def self.better_enum_attributes
      @better_enum_attributes
    end

    def self.better_enum_symbols
      @better_enum_symbols
    end

    def self.better_enum_index_location
      better_enum_attributes.index(:id) || 0
    end

    def self.values(values)
      @better_enum_values ||= Hash.new
      @better_enum_symbols ||= Hash.new

      if values.class == Hash
        values.each_with_index { |(k, v), i| handle_hash_values(k, v, i) }
      elsif values.class == Array
        values.each_with_index { |v, i| handle_array_values(v, i) }
      end
    end

    def self.groups(hash)
      hash.each do |group, ids|
        self.send(:define_singleton_method, group) do
          ids.map { |id| self.find(id) }
        end
      end
    end

    def self.belongs_to(name, options = {})
      class_name = (options[:class_name] || name.to_s.camelize).to_s
      foreign_key = (options[:foreign_key] || "#{name}_id").to_s
      
      self.send(:define_method, name) {
        klass = class_name.constantize
        klass.find(self.send(foreign_key))
      }

      self.send(:define_singleton_method, "better_enum_belongs_to_#{class_name.underscore}".upcase) {
        var_name = "@better_enum_belongs_to_#{class_name.underscore}"
        return instance_variable_get(var_name) if instance_variable_get(var_name)
        hash = Hash.new {Array.new}
        self.all.each do |obj|
          hash[obj.send(foreign_key)] = hash[obj.send(foreign_key)] << obj
        end
        instance_variable_set(var_name, hash)
        hash
      }
    end

    def self.has_many(name, options = {})
      class_name = (options[:class_name] || name.to_s.singularize.camelize).to_s
      self.send(:define_method, name) {
        klass = class_name.constantize
        klass.send("better_enum_belongs_to_#{self.class.name.underscore}".upcase)[self.id]
      }
    end

    private

    def self.handle_hash_values(k, v, i)
      v = [v] unless v.class == Array
      values_key = v[better_enum_index_location].to_i
      @better_enum_values[values_key] = v

      unless better_enum_attributes.index(:symbol)
        @better_enum_symbols[values_key] = k.to_sym
        self.send(:define_method, :symbol) { self.class.better_enum_symbols[self.instance_variable_get("@better_enum_id")] }
      end

      self.send(:define_singleton_method, k) { self.find(values_key) }

      self.send(:define_method, "#{k}?") { self.instance_variable_get("@better_enum_id") == values_key }

      const_set(k.to_s.upcase, values_key)
    end

    def self.handle_array_values(v, i)
      v = [v] unless v.class == Array
      values_key = v[better_enum_index_location].to_i
      @better_enum_values[values_key] = v
    end

  end
end