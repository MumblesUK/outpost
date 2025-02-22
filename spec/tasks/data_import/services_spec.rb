require "rails_helper"
require 'fileutils'

Rails.application.load_tasks

describe 'Services import' do
  after(:each) do
    Rake::Task["import:services"].reenable
  end

  context 'with a valid CSV' do
    let(:valid_file_path) { Rails.root.join('spec', 'fixtures', 'data_import', 'services_valid.csv') }

    it 'works' do
      expect(Service.all.count).to eq 0
      expect(Link.all.reload.count).to eq 0
      Rake::Task["import:services"].invoke(valid_file_path)
      expect(Service.all.count).to eq 2
      expect(Link.all.count).to eq 2
    end

    context 'with the services imported already' do
      before do
        Rake::Task["import:services"].invoke(valid_file_path)
        Rake::Task["import:services"].reenable
      end

      it 'does not duplicate any services or other data' do
        expect(Service.all.count).to eq 2
        expect(Link.all.count).to eq 2
        expect(Suitability.all.count).to eq 10

        Rake::Task["import:services"].invoke(valid_file_path)

        expect(Service.all.count).to eq 2
        expect(Link.all.count).to eq 2
        expect(Suitability.all.count).to eq 10
      end
    end

    context 'with custom fields in the DB' do
      let!(:custom_text_field) { FactoryBot.create :custom_field, key: 'text field' }

      before do
        FactoryBot.create :custom_field, :number, key: 'number field'
        FactoryBot.create :custom_field, :checkbox, key: 'checkbox field'
        FactoryBot.create :custom_field, :date, key: 'date field'
        FactoryBot.create :custom_field, :select, key: 'select field'
      end

      it 'creates the service meta' do
        expect(ServiceMeta.all.reload.count).to eq 0
        Rake::Task["import:services"].invoke(valid_file_path)
        expect(ServiceMeta.all.reload.count).to eq 5
      end
    end
  end

end
