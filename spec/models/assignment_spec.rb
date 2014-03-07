require 'spec_helper'

describe Assignment do
  it 'grabs the name from the command bar action' do
    assignment = Assignment.new(content: '@Professor Hubert J. Farnsworth', conversation_id: 1, person_id: 1)
    expect(assignment.name).to eq('Professor Hubert J. Farnsworth')
  end
end
