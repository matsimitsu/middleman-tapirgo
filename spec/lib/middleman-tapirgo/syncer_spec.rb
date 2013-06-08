require 'spec_helper'

describe Middleman::Tapirgo::Syncer do

  let(:syncer) { Middleman::Tapirgo::Syncer.new(:api_key => 'bananas') }
  before { syncer.stub(:puts => true) }

  describe "#inst" do
    subject { syncer.inst.class.name }

    it "should return an instance of middleman" do
      should == 'Middleman::Application::MiddlemanApplication1'
    end
  end

  describe "#options" do
    subject { syncer.options }

    it "should return a hash with the options" do
      should == { :api_key => 'bananas' }
    end
  end

  describe "#uri" do
    subject { syncer.uri.to_s }

    it "should return the correct URI" do
      should == "http://tapirgo.com/api/1/push_article.json?secret=bananas"
    end
  end

  describe "#syncable_items" do
    let(:resources) { [mock(:ext => '.html'), mock(:ext => '.css')] }

    before do
      syncer.stub_chain(:inst, :sitemap, :resources => resources)
    end
    subject { syncer.syncable_items }

    it "should return an array with html files from the sitemap" do
      should == [resources.first]
    end
  end

  describe "sync" do
    let(:resource) { mock(:ext => '.html') }
    let(:syncable_item) { mock(:to_hash => {'a' => 'b'}, :link => 'index.html') }
    let(:response) { mock(:code => '200') }
    before do
      Middleman::Tapirgo::SyncableItem.stub(:new => syncable_item)
      syncer.stub(
        :syncable_items => [resource],
        :send_to_tapirgo => response
      )
    end

    describe "with api key" do

      it "should get a new syncable item" do
        Middleman::Tapirgo::SyncableItem.
          should_receive(:new).
          with(resource)
      end

      it "should send the item to tapirgo" do
        syncer.should_receive(:send_to_tapirgo).with(syncable_item)
      end

      context "when the respone code is not 200: OK" do
        before { response.stub(:code => '404', :message => 'not found') }

        it "should puts a message telling the user" do
          syncer.
            should_receive(:puts).
            with('Failed sending index.html to TapirGo')

          syncer.
            should_receive(:puts).
            with('Response 404 not found')
        end
      end

      after { syncer.sync }
    end

    context "without api_key" do
      let(:syncer_without_api_key) do
        Middleman::Tapirgo::Syncer.new
      end

      it "should not call syncable items" do
        syncer_without_api_key.should_not_receive(:syncable_items)
      end

      after { syncer_without_api_key.sync }
    end
  end

  describe "#send_to_tapirgo" do
    let(:item) { mock(:to_hash => {'a' => 'b'}) }
    before do
      stub_request(:post, "http://tapirgo.com/api/1/push_article.json").
        with(:body => "{\"a\":\"b\"}",
             :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => "", :headers => {})

      syncer.send_to_tapirgo(item)
    end

    it "should post the item to tapirgo" do
      WebMock.should have_requested(
        :post, "http://tapirgo.com/api/1/push_article.json?secret=bananas"
      ).with(
        :body => "{\"a\":\"b\"}",
        :headers => {
          'Accept' => '*/*',
          'Content-Type' => 'application/json'
        }
      ).once
    end
  end

end
