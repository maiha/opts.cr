class VarNotInitialized < Exception
end

class Object
  macro val(name, default)
    @{{name.var.id}} : {{name.type}}?
    def {{name.var.id}}
      if @{{name.var.id}}.nil?
        @{{name.var.id}} = ({{default}})
        if @{{name.var.id}}.nil?
          raise VarNotInitialized.new("val `{{name.var.id}}` must be initialized, but got nil in #{__FILE__}:#{__LINE__}")
        end
      end
      @{{name.var.id}}.not_nil!
    end
  end
  
  macro val(name)
    {% if name.is_a?(Assign) %}
       val_assign({{name}})
    {% elsif name.is_a?(TypeDeclaration) %}
       val_type_declaration({{name}})
    {% end %}
  end
  
  # assign : Assign
  macro val_assign(assign)
    def {{assign.target}}
      {{assign.value}}
    end
  end
  
  # name : TypeDeclaration
  #   def var : MacroId
  #   def type : ASTNode
  #   def value : ASTNode | Nop
  macro val_type_declaration(name)
    @{{name.var.id}} : {{name.type}}?
    def {{name.var.id}}
      if @{{name.var.id}}.nil?
        @{{name.var.id}} = ({{name.value}})
        if @{{name.var.id}}.nil?
          raise VarNotInitialized.new("val `{{name.var.id}}` must be initialized, but got nil in #{__FILE__}:#{__LINE__}")
        end
      end
      @{{name.var.id}}.not_nil!
    end
  end
  
  macro var(name, default)
    def {{name.var.id}}
      if @{{name.var.id}}.nil?
        {{default}}
      else
        if @{{name.var.id}}.nil?
          raise VarNotInitialized.new("var `{{name.var.id}}` must be initialized, but got nil in #{__FILE__}:#{__LINE__}")
        end
        @{{name.var.id}}.not_nil!
      end
    end
  
    def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
    end
  end
  
  # name : TypeDeclaration
  #   def var : MacroId
  #   def type : ASTNode
  #   def value : ASTNode | Nop
  macro var(name)
    def {{name.var.id}}
      if @{{name.var.id}}.nil?
        @{{name.var.id}} = ({{name.value}})
      end
  
      # String? = "String | ::Nil"
      {% if name.type.stringify =~ / ::Nil$/ %}
        @{{name.var.id}}
      {% else %}
        if @{{name.var.id}}.nil?
          raise VarNotInitialized.new("var `{{name.var.id}}` must be initialized, but got nil in #{__FILE__}:#{__LINE__}")
        else
          @{{name.var.id}}.not_nil!
        end
      {% end %}
    end
  
    def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
    end
  end
end
