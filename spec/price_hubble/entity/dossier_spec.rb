# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PriceHubble::Dossier do
  let(:instance) { build(:dossier) }
  let(:existing_id) { '301785bc-ec45-4183-ae58-48abd2a0f1d0' }

  describe '#save!', vcr: cassette(:dossier, :save) do
    let(:action) { instance.save! }

    it 'returns true' do
      expect(action).to be(true)
    end

    it 'assigns an identitifer' do
      expect { action }.to change(instance, :id).from(nil).to(existing_id)
    end
  end

  describe '#delete!' do
    let(:action) { instance.delete! }

    before { instance.id = id }

    context 'with existing dossier', vcr: cassette(:dossier, :delete, :exist) do
      let(:id) { existing_id }

      it 'does not raise any error' do
        expect { action }.not_to raise_error
      end
    end

    context 'with existing dossier', vcr: cassette(:dossier, :delete, :miss) do
      let(:id) { 'b1e2fedc-ea44-43a4-948a-2fb10747b8fe' }

      it 'raises a PriceHubble::EntityNotFound error' do
        expect { action }.to raise_error(PriceHubble::EntityNotFound)
      end
    end
  end

  describe '#link!', vcr: cassette(:dossier, :link) do
    let(:action) { instance.link! }

    before do
      instance.id = existing_id
      instance.changes_applied
    end

    it 'returns a dossier link URL' do
      expect(action).to \
        start_with('https://dash.pricehubble.com/shared/dossier/ey')
    end
  end
end
