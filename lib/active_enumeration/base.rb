require 'active_support/inflector'

module ActiveEnumeration
  class Base

    def self.find(id)
      id = active_enumeration_to_id(id)
      @instances ||= {}
      unless @instances[id] || !@active_enumeration_values[id]
        @instances[id] = self.new *@active_enumeration_values[id]
      end
      @instances[id]
    end

    def self.where(filters)
      self.all.select do |enum|
        filters.keys.all? { |k| enum.send(k) == filters[k] }
      end
    end

    def self.all
      @active_enumeration_values.keys.map { |id| self.find(id) }
    end

    def self.count
      @active_enumeration_values.count
    end

    def self.to_a
      all.map { |e| [e.to_s, e.instance_variable_get("@active_enumeration_id")] }
    end

    def symbol
      self.instance_variable_get("@symbol")
    end

    protected

    def self.attr_reader(*attributes)
      super
      @active_enumeration_attributes ||= []
      @active_enumeration_attributes.concat(attributes.map(&:to_sym))
    end

    def initialize(*attributes)
      key_index = self.class.active_enumeration_index_location
      self.instance_variable_set("@active_enumeration_id", self.class.active_enumeration_to_id(attributes[key_index]))

      self.class.active_enumeration_attributes.each_with_index do |attr_name, index|
        self.instance_variable_set("@#{attr_name}", attributes[index])
      end
    end

    def self.active_enumeration_attributes
      @active_enumeration_attributes
    end

    def self.active_enumeration_symbols
      @active_enumeration_symbols
    end

    def self.active_enumeration_index_location
      active_enumeration_attributes.index(:id) || 0
    end

    def self.active_enumeration_to_id(id)
      id
    end

    def self.values(values)
      @active_enumeration_values ||= Hash.new
      @active_enumeration_symbols ||= Hash.new

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

      self.send(:define_singleton_method, "active_enumeration_belongs_to_#{class_name.underscore}".upcase) {
        var_name = "@active_enumeration_belongs_to_#{class_name.underscore}"
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
        klass.send("active_enumeration_belongs_to_#{self.class.name.underscore}".upcase)[self.id]
      }
    end

    private

    def self.handle_hash_values(k, v, i)
      v = [v] unless v.class == Array
      values_key = active_enumeration_to_id(v[active_enumeration_index_location])
      @active_enumeration_values[values_key] = v

      unless active_enumeration_attributes.index(:symbol)
        @active_enumeration_symbols[values_key] = k.to_sym
        self.send(:define_method, :symbol) { self.class.active_enumeration_symbols[self.instance_variable_get("@active_enumeration_id")] }
      end

      self.send(:define_singleton_method, k) { self.find(values_key) }

      self.send(:define_method, "#{k}?") { self.instance_variable_get("@active_enumeration_id") == values_key }

      const_set(k.to_s.upcase, values_key)
    end

    def self.handle_array_values(v, i)
      v = [v] unless v.class == Array
      values_key = active_enumeration_to_id(v[active_enumeration_index_location])
      @active_enumeration_values[values_key] = v
    end

  end
end