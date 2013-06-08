require 'spec_helper'

describe Middleman::Tapirgo::SyncableItem do

  let(:resource) do
    mock(
      :render => 'story about moo',
      :data => {
        'date' => '01-01-2001 10:00:00 UTC',
        'title' => 'moo'
      },
      :path => 'index.html',
      :source_file => '/resources/index.html'
    )
  end
  let(:syncable_item) { Middleman::Tapirgo::SyncableItem.new(resource) }

  describe "#content" do

    it "should call render on the resource" do
      resource.should_receive(:render).with(:layout => nil)
    end

    after { syncable_item.content }
  end

  describe "#published_on" do
    subject { syncable_item.published_on }

    it { should == Time.parse('01-01-2001 10:00:00 UTC') }

    context "when data['time'] is missing" do
      let(:resource) do
        mock(
          :data => {},
          :source_file => '/resources/index.html'
        )
      end

      it "sould call File.mtime" do
        File.should_receive(:mtime).with('/resources/index.html')
      end

      after { syncable_item.published_on }
    end
  end

  describe "#title"do
    subject { syncable_item.title }

    it { should == 'moo' }

    context "without title in the data" do
      let(:resource) { mock(:data => {}, :path => 'index.html') }

      it { should == 'index.html' }
    end
  end

  describe "#link" do
    subject { syncable_item.link }

    it { should == 'index.html' }
  end

  describe "#to_hash" do
    subject { syncable_item.to_hash }

    it "should return a TapirGo compatible hash" do
      should == {
        :title => 'moo',
        :content => 'story about moo',
        :link => 'index.html',
        :published_on => Time.parse('01-01-2001 10:00:00 UTC')
      }
    end
  end

end
