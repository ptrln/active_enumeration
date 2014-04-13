require 'active_support/inflector'

module ActiveEnum
  class Base

    def self.attr_reader(*attributes)
      super

      @active_enum_attributes ||= []
      @active_enum_attributes.concat(attributes.map(&:to_sym))
    end

    def initialize(*attributes)
      key_index = self.class.active_enum_index_location
      self.instance_variable_set("@active_enum_id", attributes[key_index].to_i)

      self.class.active_enum_attributes.each_with_index do |attr_name, index|
        self.instance_variable_set("@#{attr_name}", attributes[index])
      end
    end

    def self.active_enum_attributes
      @active_enum_attributes
    end

    def self.active_enum_index_location
      active_enum_attributes.index(:id) || 0
    end

    def self.values(values)
      @active_enum_values ||= Hash.new

      if values.class == Hash
        values.each_with_index do |(k, v), values_index|
          v = [v] unless v.class == Array

          values_key = v[active_enum_index_location].to_i

          @active_enum_values[values_key] = v

          self.send(:define_singleton_method, k) { self.find(values_key) }

          # if self.instance_eval { |i| i.respond_to? :name }
          #   self.send(:define_singleton_method, :find_by_name) do |name|
          #     index = self.all.index { |o| o.name == name }
          #     self.all[index] if index
          #   end
          # end

          self.send(:define_method, "#{k}?") { self.instance_variable_get("@active_enum_id") == values_key}

          const_set(k.to_s.upcase, values_key)
        end
      elsif values.class == Array
        values.each do |v|
          v = [v] unless v.class == Array


          values_key = v[active_enum_index_location].to_i

          @active_enum_values[values_key] = v
          # if self.instance_eval { |i| i.respond_to? :name }
          #   self.send(:define_singleton_method, :find_by_name) do |name|
          #     index = self.all.index { |o| o.name == name }
          #     self.all[index] if index
          #   end
          # end
        end
      end
    end

    def self.groups(hash)
      hash.each do |group, ids|
        self.send(:define_singleton_method, group) do
          ids.map { |id| self.find(id) }
        end
      end
    end

    def self.find(id)
      id = id.to_i
      @instances ||= {}
      unless @instances[id] || !@active_enum_values[id]
        @instances[id] = self.new *@active_enum_values[id]
      end
      @instances[id]
    end

    def self.belongs_to(name, options = {})
      class_name = (options[:class_name] || name.to_s.camelize).to_s
      foreign_key = (options[:foreign_key] || "#{name}_id").to_s
      
      self.send(:define_method, name) {
        klass = class_name.constantize
        klass.find(self.send(foreign_key))
      }

      self.send(:define_singleton_method, "belongs_to_#{class_name.underscore}".upcase) {
        var_name = "@belongs_to_#{class_name.underscore}"
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
        klass.send("belongs_to_#{self.class.name.underscore}".upcase)[self.id]
      }
    end

    def self.all
      @active_enum_values.keys.map { |id| self.find(id) }
    end

    def self.count
      @active_enum_values.count
    end

    def self.to_a
      all.map { |e| [e.to_s, e.instance_variable_get("@active_enum_id")]}
    end



  end
end