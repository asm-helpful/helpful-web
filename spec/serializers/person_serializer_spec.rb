require 'spec_helper'

describe PersonSerializer do

  before do
    @person = Struct.new(:created_at, :updated_at).new(
      Time.now,
      Time.now
    )
  end

  it "created" do
    serializer = PersonSerializer.new(@person)
    assert Time.iso8601(serializer.created)
  end

  it "updated" do
    serializer = PersonSerializer.new(@person)
    assert Time.iso8601(serializer.updated)
  end

end
