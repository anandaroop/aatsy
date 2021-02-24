class Subject < ApplicationRecord
  include Elasticsearch::Model
  index_name "aatsy_subjects"

  has_ancestry cache_depth: true
  has_many :terms
  has_many :scope_notes

  FACETS = {
    activities: 300264090,
    agents: 300264089,
    associated_concepts: 300264086,
    brand_names: 300343372,
    materials: 300264091,
    objects: 300264092,
    physical_attributes: 300264087,
    styles_and_periods: 300264088,
  }

  RECORD_TYPES = {
    'C' => "Concept",
    'F' => "Facet",
    'G' => "Guide term",
    'H' => "Hierarchy name"
  }

  # ELASTICSEARCH

  mappings dynamic: 'false' do
    indexes :name, type: 'text'
    indexes :suggest, type: 'completion'
    indexes :facet_name, type: 'keyword'
    indexes :record_type, type: 'keyword'
    indexes :ancestor_ids, type: 'keyword'
    indexes :ancestor_names, type: 'keyword'
    indexes :scope_note, type: 'text'
    indexes :terms, type: 'text'
  end

  def as_indexed_json(options = {})
    {
      name: name,
      suggest: suggestions,
      facet_name: facet && facet.name.split[0],
      record_type: record_type_name,
      ancestry: ancestry,
      ancestor_ids: ancestor_ids,
      ancestor_names: ancestor_names,
      scope_note: scope_note,
      terms: terms.map(&:term)
    }
  end

  def suggestions
    ([]).tap do |suggestions|
      suggestions << { input: name, weight: 8 }
      suggestions << { input: terms.map(&:term), weight: 3 }
      suggestions << { input: parent.name, weight: 2 } if has_parent?
    end
  end

  # returns db-backed instances
  def self.query(term, options = {})
    body = {
      query: {
        multi_match: {
          query: term,
          fields: [ "name^10", "scope_note^5", "terms^3", "ancestor_names"]
        }
      }
    }.merge(options) # from, size, etc

    Subject.search(body)
  end

  # for perf reasons, returns search hits directly from ES index, not db-backed instances
  def self.complete(prefix, options = {})
      body = {
      suggest: {
        subjects: {
          prefix: prefix,
          completion: {
            field: "suggest"
          }
        }
      }
    }.merge(options) # from, size, etc

    Subject.search(body).response['suggest']['subjects'].first['options']
  end

  # Can follow the query search syntax:
  # https://www.elastic.co/guide/en/elasticsearch/reference/5.6/query-dsl-query-string-query.html#query-string-syntax
  #
  # For example:
  #
  # Subject.console_search('"bronze age" name:"bronze age"^2 NOT record_type:C', size: 3)
  #
  def self.console_search(q, options = {})
    # use search hits retrieved from es
    results = Subject.search(q, options).results
    results.each do |s|
        puts "\n%s %s %s %s %s\n%s\n%s\n%s" % [
        s.name&.bold,
        s.facet_name&.green,
        s.record_type&.light_blue,
        s._score.to_s.light_magenta,
        s._id.light_black,
        (s.ancestor_names[2..] || []).join(" ‣ ").cyan,
        s.scope_note,
        s.terms.join("; ").light_black
      ]
    end
    results.total
  end

  def self.recreate_index!(arel = nil)
    __elasticsearch__.create_index! force: true
    if arel
      arel.import
    end
  end

  # CLASS METHODS

  # The root of the AAT hierarchy, identified by a special id
  def self.root
    Subject.find(300000000)
  end

  # The AAT Facets are the immediate children of the root node
  def self.facets
    root.children
  end

  def self.facet(slug)
    find(FACETS[slug])
  end

  # INSTANCE METHODS

  def to_s
    "<Subject #{ancestor_names[1..].join(" > ")}>"
  end

  def facet
    ancestors[1]
  end

  def subfacet
    ancestors[2]
  end

  def facet_from_code
    return unless facet_code.present?
    FacetCode.find(facet_code)&.subject
  end

  def record_type_name
    RECORD_TYPES[record_type]
  end

  def ancestor_names
    @ancestor_names = ancestors.map(&:name)
  end

  def ancestor_map
    @ancestor_map = ancestor_names.zip(ancestor_ids).to_h
  end

  def scope_note
    # english code, by default
    scope_notes.find_by(language_code: 70051)&.note_text
  end

  #tmp utils
  def self.sample; offset(rand(count)).limit(1).first; end
  def self.metal; find(300010900); end
  def self.bronze; find(300010957); end
end
