require 'test/unit'
require File.dirname(__FILE__)+'/test_helper'

class ApiTest < Test::Unit::TestCase
  include Freebase::Api
  def test_find_single_record
    record = mqlread(:id => "/en/the_polyphonic_spree", :name => nil)
    assert_instance_of FreebaseResult, record
    assert_equal "The Polyphonic Spree", record.name
  end
  def test_find_raw_data
    data = mqlread({:id => "/en/the_polyphonic_spree", :name => nil}, :raw => true)
    assert_instance_of Hash, data
    assert_equal "The Polyphonic Spree", data['name']
  end
  def test_find_multiple_records
    data = mqlread([{:type => '/music/artist', :name => nil, :'name~=' => '^Tori '}], :raw => true)
    assert_instance_of Array, data
    assert data.map{|artist| artist['name']}.include?('Tori Amos')
  end
end