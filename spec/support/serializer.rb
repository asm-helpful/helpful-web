shared_examples "a serializer" do

  it "builds" do
    expect {
      subject.to_json
    }.to_not raise_error
  end

end
