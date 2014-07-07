require 'spec_helper'

describe AvatarHelper do
  let(:person) { Person.new(email: 'test@example.com') }

  describe '#avatar_default' do
    it 'creates an avatar with default values' do
      expect(avatar_default(person)).to eq('<img alt="55502f40dc8b7c769880b10874abc9d0" class="avatar" height="20" src="https://secure.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.png?s=40&amp;d=identicon" width="20" />')
    end
  end

  describe '#avatar_path' do
    context 'when the person have an uploaded avatar' do
      let(:person) { double('person') }
      let(:avatar) { double('avatar') }
      let(:thumb) { '/path/to/my/avatar.png' }

      before do
        allow(person).to receive(:avatar) { avatar }
        allow(avatar).to receive(:thumb) { thumb }
      end

      it 'should return the thumb path' do
        expect(avatar_path(person, 30)).to eq(thumb)
      end
    end
  end

  describe '#gravatar_url' do
    it 'returns a url for the persons avatar for a given size' do
      expect(gravatar_url(person.email, 30)).to eq('https://secure.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.png?s=30&d=identicon')
    end
  end
end
