class QueryObjectBase
  prepend ActiveCacher.instance
  extend DslAttribute

  QUERY_METHODS = %i[
    joins includes preload eager_load references select where not or order limit offset none except
  ] + (defined?(ArLazyPreload) ? %i[lazy_preload] : [])
  DELEGATE_METHODS = %i[== === eql? equal?]

  vattr_initialize :scope

  # …existing methods like to_a, to_ary, paginate remain unchanged…

  QUERY_METHODS.each do |method_name|
    define_method method_name do |*args|
      chain @scope.public_send(method_name, *args)
    end
  end

  DELEGATE_METHODS.each do |method_name|
    define_method method_name do |*args|
      @scope.send(method_name, *args)
    end
  end

  def lazy_map(&block)
    chain TransformedCollection.new(@scope, :map, block)
  end

  def lazy_filter(&block)
    chain TransformedCollection.new(@scope, :filter, block)
  end

  # ✅ Fixed dynamic delegation
  def respond_to_missing?(method_name, include_private = false)
    super || @scope.respond_to_missing?(method_name, include_private)
  end

def method_missing(method_name, *args, &block)
  if @scope.respond_to?(method_name)
    @scope.public_send(method_name, *args, &block)
  elsif method_name == :paginate
    # 🛡️ The Shield: If paginate is called but doesn't exist, 
    # just return the scope as-is instead of crashing.
    @scope 
  else
    super
  end
end

private

  def chain(scope)
    self.class.new(scope)
  end
end
