require 'with_model/base'

module WithModel
  class ModelDestroyer
    def self.destroy(model)
      new(model).destroy
    end

    def initialize model
      @model = model
    end

    def destroy
      remove_from_dependencies
      remove_from_descendants
    end

    private

    def remove_from_dependencies
      return unless defined?(ActiveSupport::Dependencies::Reference)
      ActiveSupport::Dependencies::Reference.clear!
    end

    def remove_from_descendants
      return unless @model.superclass.respond_to?(:direct_descendants)
      @model.superclass.direct_descendants.delete(@model)
    end
  end
  private_constant :ModelDestroyer
end
