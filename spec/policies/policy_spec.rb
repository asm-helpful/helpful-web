require 'spec_helper'

describe Policy do

  it "is restrictive by default" do
    expect(subject).to_not be_access
  end

end
