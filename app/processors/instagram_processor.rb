module Processors
  class InstagramProcessor < Processors::Base
    protected

    def entities
      nodes.map { |node| [node['shortcode'], node] }.to_h
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
      source.dig(*EDGES_PATH)
    end

    def nodes
      edges.map { |edge| edge['node'] }
    end
  end
end
