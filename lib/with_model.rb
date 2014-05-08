require 'with_model/model'
require 'with_model/model/dsl'
require 'with_model/table'
require 'with_model/version'

module WithModel
  def with_model(name, options = {}, &block)
    model = Model.new name, options
    dsl = Model::DSL.new model
    dsl.instance_exec(&block) if block

    before(:all) { model.create }
    after (:all) { model.destroy }
  end

  def with_table(name, options = {}, &block)
    table = Table.new name, options, &block

    before(:all) { table.create }
    after (:all) { table.destroy }
  end
end
