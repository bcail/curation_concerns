require 'spec_helper'

describe CurationConcerns::WorkBehavior do
  before do
    class EssentialWork < ActiveFedora::Base
      include CurationConcerns::WorkBehavior
    end
  end
  after do
    Object.send(:remove_const, :EssentialWork)
  end

  subject { EssentialWork.new }

  it 'mixs together all the goodness' do
    [::CurationConcerns::WithFileSets, ::CurationConcerns::HumanReadableType, CurationConcerns::Noid, CurationConcerns::Serializers, Hydra::WithDepositor, Hydra::AccessControls::Embargoable, Solrizer::Common].each do |mixin|
      expect(subject.class.ancestors).to include(mixin)
    end
  end
  describe '#to_s' do
    it 'uses the provided titles' do
      subject.title = %w(Hello World)
      expect(subject.to_s).to eq('Hello | World')
    end
  end

  describe 'human_readable_type' do
    it 'has a default' do
      expect(subject.human_readable_type).to eq 'Essential Work'
    end
    it 'is settable' do
      EssentialWork.human_readable_type = 'Custom Type'
      expect(subject.human_readable_type).to eq 'Custom Type'
    end
  end

  it 'inherits (and extends) to_solr behaviors from superclass' do
    expect(subject.to_solr.keys).to include(:id)
    expect(subject.to_solr.keys).to include('has_model_ssim')
  end
end
