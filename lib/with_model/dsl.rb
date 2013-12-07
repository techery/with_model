require 'active_support/core_ext/string/inflections'
require 'with_model/base'
require 'with_model/model_creator'
require 'with_model/model_destroyer'

module WithModel
  class Dsl
    NOOP = lambda {|*|}

    def initialize(name, example_group)
      @name = name
      @example_group = example_group
      @model_initialization = NOOP
      @table_block = NOOP
      @table_options = {}
    end

    def table(options = {}, &block)
      @table_options = options
      @table_block = block
    end

    def model(&block)
      @model_initialization = block
    end

    def execute
      model = nil
      creator = ModelCreator.new @name, @model_initialization
      destroyer = ModelDestroyer

      @example_group.with_table(creator.table_name, @table_options, &@table_block)

      @example_group.before do
        model = creator.create
        stub_const(creator.const_name, model)
      end

      @example_group.after do
        destroyer.destroy model
      end
    end
  end
end
