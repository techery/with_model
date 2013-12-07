require 'with_model/base'

module WithModel
  class ModelCreator
    def initialize name, model_initialization
      @name = name
      @model_initialization = model_initialization
    end

    def create
      this = self
      model_initialization = @model_initialization

      model = Class.new(WithModel::Base) do
        self.table_name = this.table_name
        self.class_eval(&model_initialization)
      end
      model.reset_column_information
      model
    end

    def const_name
      @name.to_s.camelize.freeze
    end

    def table_name
      "with_model_#{@name.to_s.tableize}_#{$$}".freeze
    end
  end
  private_constant :ModelCreator
end
