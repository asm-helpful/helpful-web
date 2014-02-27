require 'spec_helper'

describe NicknameHelper do

  it "picks the best nickname for a person" do
    person = double('Person', name: 'Chris')
    expect(helper.nickname(person)).to eq('Chris')
  end

end
