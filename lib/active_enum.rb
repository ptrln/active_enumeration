require 'active_support/inflector'
require 'active_enum/base'

module ActiveEnum

  def self.extended(receiver)
    receiver.extend ClassMethods
  end

  module ClassMethods

    def has_active_enum_for(name, options = {})
      class_name = (options[:class_name] || name.to_s.camelize).to_s
      foreign_key = (options[:foreign_key] || "#{name}_id").to_s

      self.send(:define_method, name) do
        klass = class_name.constantize
        klass.find(self.send(foreign_key))
      end

      self.send(:define_method, "#{name}=") do |enum_obj|
        self.send("#{foreign_key}=", enum_obj.id)
      end
    end
  end

end