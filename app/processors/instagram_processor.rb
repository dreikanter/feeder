class InstagramProcessor < BaseProcessor
  protected

  def entities
    nodes.map { |node| entity(node['shortcode'], node) }
  end

  EDGES_PATH = [
    'entry_data',
    'ProfilePage',
    0,
    'graphql',
    'user',
    'edge_owner_to_timeline_media',
    'edges'
  ].freeze

  def edges
    content.dig(*EDGES_PATH)
  end

  def nodes
    edges.map { |edge| edge['node'] }
  end
end
