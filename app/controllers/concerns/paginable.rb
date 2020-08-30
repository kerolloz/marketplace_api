module Paginable
  protected

  def current_page
    (params[:page] || 1).to_i
  end

  def per_page
    (params[:per_page] || 20).to_i
  end

  def get_pagination_links_serializer_options(links_path, collection)
    {
      links: {
        first: send(links_path, page: 1),
        last: send(links_path, page: collection.total_pages),
        prev: send(links_path, page: collection.prev_page),
        next: send(links_path, page: collection.next_page),
      }
    }
  end
end
