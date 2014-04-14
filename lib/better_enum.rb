require 'active_support/inflector'
require 'better_enum/base'

module BetterEnum

  def self.extended(receiver)
    receiver.extend ClassMethods
  end

  module ClassMethods

    def has_better_enum_for(name, options = {})
      class_name = (options[:class_name] || name.to_s.camelize).to_s
      foreign_key = (options[:foreign_key] || "#{name}_id").to_s

      self.send(:define_method, name) do
        klass = class_name.constantize
        klass.find(self.send(foreign_key))
      end

      self.send(:define_method, "#{name}=") do |enum_obj|
        self.send("#{foreign_key}=", enum_obj.instance_variable_get("@better_enum_id"))
      end
    end

    def has_better_enums_for(name, options = {})
      class_name = (options[:class_name] || name.to_s.camelize).to_s
      foreign_key = (options[:foreign_key] || "#{name.to_s.singularize}_ids").to_s

      self.send(:define_method, name) do
        klass = class_name.constantize
        self.send(foreign_key).map { |id| klass.find(id) }
      end

      self.send(:define_method, "#{name}=") do |enum_objs|
        self.send("#{foreign_key}=", enum_objs.map { |obj| obj.instance_variable_get("@better_enum_id") })
      end
    end
  end

end