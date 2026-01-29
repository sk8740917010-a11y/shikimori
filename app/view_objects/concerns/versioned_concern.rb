module VersionedConcern
  extend ActiveSupport::Concern

  VERSIONS_PER_PAGE = 20

  def parameterized_versions
    relation = versions_scope
    page = [h.params[:page].to_i, 1].max
    
    # 1. Manual Pagination using limit and offset
    paginated = relation.limit(VERSIONS_PER_PAGE).offset((page - 1) * VERSIONS_PER_PAGE)

    # 2. Decorate the collection
    decorated = paginated.decorate
    
    # 3. Mock the pagination methods will_paginate expects in the view
    # This prevents the "undefined method" errors
    total_count = relation.count(:all)
    total_pages = (total_count.to_f / VERSIONS_PER_PAGE).ceil

    decorated.singleton_class.class_eval do
      define_method(:total_pages)   { total_pages }
      define_method(:current_page)  { page }
      define_method(:next_page)     { page < total_pages ? page + 1 : nil }
      define_method(:previous_page) { page > 1 ? page - 1 : nil }
      define_method(:next_page?)    { page < total_pages }
      define_method(:total_entries) { total_count }
      define_method(:per_page)      { VERSIONS_PER_PAGE }
    end

    decorated
  end

  private

  def versions_scope
    query = VersionsQuery.by_item(object, h.params[:field])
    # Ensure the query object returns the actual relation
    query.respond_to?(:scope) ? query.scope : query
  end
end