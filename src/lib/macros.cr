macro val(name, default)
  @{{name.var.id}} : {{name.type}}?
  def {{name.var.id}}
    if @{{name.var.id}}.nil?
      @{{name.var.id}} = ({{default}})
      if @{{name.var.id}}.nil?
        raise "val `{{name.var.id}}` must be initialized, but got nil in #{__FILE__}:#{__LINE__}"
      end
    end
    @{{name.var.id}}.not_nil!
  end
end

# name : TypeDeclaration
#   def var : MacroId
#   def type : ASTNode
#   def value : ASTNode | Nop
macro val(name)
  @{{name.var.id}} : {{name.type}}?
  def {{name.var.id}}
    if @{{name.var.id}}.nil?
      @{{name.var.id}} = ({{name.value}})
      if @{{name.var.id}}.nil?
        raise "val `{{name.var.id}}` must be initialized, but got nil in #{__FILE__}:#{__LINE__}"
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
        raise "var `{{name.var.id}}` must be initialized, but got nil in #{__FILE__}:#{__LINE__}"
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
      @{{name.var.id}}.not_nil!
    {% end %}
  end

  def {{name.var.id}}=(@{{name.var.id}} : {{name.type}})
  end
end
