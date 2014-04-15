require 'spec_helper'

describe Mongoid::Graph do
  # Mongoid::Graph provides a directed graph structure atop Mongoid.
  # Some functionality —like traversing— found in graph databases is included.
  #
  # It allows you to use your models as graph elements: nodes and links,
  # it does not create or destroy these elements for you, instead manages
  # the relationships between them.
  #
  # Said so, for *connections* all the intervining elements must be specified.

  class Person
    include Mongoid::Document
    include Mongoid::Graph::Node
  end

  class Pokemon
    include Mongoid::Document
    include Mongoid::Graph::Node
  end
  
  class Friend
    include Mongoid::Document
    include Mongoid::Graph::Link
  end

  before do
    @alice = Person.create
    @bob   = Person.create
    @zack  = Pokemon.create
  end

  context 'connection through implicit link' do
  
    it 'connects nodes' do
      @alice.connect_to(@bob)
      @alice.connect_to(@zack)
      @bob.connect_to(@zack)
      
      alice = [@alice.class.to_s, @alice.id]
      bob   = [@bob.class.to_s, @bob.id]
      zack  = [@zack.class.to_s, @zack.id]

      expect( @alice.successors  ).to eq( [bob, zack] )
      expect( @bob.predecessors  ).to eq( [alice] )
      expect( @bob.successors    ).to eq( [zack] )
      expect( @zack.predecessors ).to eq( [alice, bob] )
    end

    it 'connect_to() returns connection elements' do
      expect( @alice.connect_to(@bob) ).to eq( {source: @alice, link: nil, target: @bob} )
    end

  end

  context 'connection through explicit link' do

    before do
      @alice_to_bob = Friend.create
    end

    it 'connects nodes' do
      alice = [@alice.class.to_s, @alice.id]
      bob   = [@bob.class.to_s, @bob.id]
      link  = [@alice_to_bob.class.to_s, @alice_to_bob.id]

      @alice.connect_to(@bob, @alice_to_bob)

      expect( @alice.successors ).to eq( [bob + link] )
      expect( @bob.predecessors ).to eq( [alice + link] )
      expect( @alice_to_bob.source ).to eq( alice )
      expect( @alice_to_bob.target ).to eq( bob )
    end

    it 'connect_to() returns connection elements' do
      expect( @alice.connect_to(@bob, @alice_to_bob) ).to eq(
        {source: @alice, link: @alice_to_bob, target: @bob} )
    end
  
    it 'raises an exception if the provided link already connects two nodes' do
      @alice.connect_to(@bob, @alice_to_bob)

      expect{ @alice.connect_to(@zack, @alice_to_bob) }.to raise_error( Mongoid::Graph::LinkError )
    end

  end

  it 'filters endpoints by a combination of direction, node and link classes' do
    @alice.connect_to(@bob, Friend.create)
    @alice.connect_to(@zack)
    @zack.connect_to(@alice)

    expect( @alice.endpoints() ).to eq( [@zack, @bob] )
    expect( @alice.endpoints(:in) ).to eq( [@zack] )
    expect( @alice.endpoints(:out) ).to eq( [@bob, @zack] )
    # expect( @alice.endpoints(nodes: Pokemon) ).to eq( [@zack] )
    # expect( @alice.endpoints(nodes: Nothing) ).to eq( [] )
    # expect( @alice.endpoints(nodes: [Pokemon, Nothing]) ).to eq( [@zack] )
    # # Node and link classes filtering is done using kind_of?().
    # expect( @alice.endpoints(nodes: Object) ).to eq( [@bob, @zack] )
    # expect( @alice.endpoints(nodes: [Person, Pokemon]) ).to eq( [@bob, @zack] )
    # expect( @alice.endpoints(links: Friend) ).to eq( [@bob] )
    # expect( @alice.endpoints(links: [Friend, Nil]) ).to eq( [@bob, @zack] )
    # expect( @alice.endpoints(:out, nodes: Object, links: Friend) ).to eq( [@bob] )
  end

  it 'filters links'
  it 'filters by properties'
  it 'has filters with chainable results'
  it 'has handy aliases for common endpoints() cases'
  it 'disconnects nodes' do
    pending 'Algo hay hecho'
  end
  it 'updates the graph properly upon a document deletion'
  # Array of nodes and links, or nodes and a block for building links.
  it 'has bulk operations'
  it 'has callbacks'
  it 'has validations'

  it 'generates dot language description' do
    @alice.connect_to(@bob)
    @alice.connect_to(@zack)
    @bob.connect_to(@zack)

    graph = "digraph g {\n  #{@alice.id} -> #{@bob.id};\n  #{@alice.id} -> #{@zack.id};\n  #{@bob.id} -> #{@zack.id};\n}"

    expect( Mongoid::Graph.dot([@alice, @bob, @zack]) ).to eq( graph )
  end

end
