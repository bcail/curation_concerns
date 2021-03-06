require 'spec_helper'

describe CurationConcerns::SingleUseLinksViewerController do
  routes { CurationConcerns::Engine.routes }
  let(:file) do
    file = FileSet.create do |lfile|
      lfile.label = 'world.png'
      lfile.apply_depositor_metadata('mjg')
    end
    Hydra::Works::AddFileToFileSet.call(file, File.open(fixture_path + '/world.png'), :original_file)
    file
  end

  describe "retrieval links" do
    let :show_link do
      SingleUseLink.create itemId: file.id, path: Rails.application.routes.url_helpers.curation_concerns_file_set_path(id: file)
    end

    let :download_link do
      SingleUseLink.create itemId: file.id, path: Rails.application.routes.url_helpers.download_path(id: file)
    end

    let :show_link_hash do
      show_link.downloadKey
    end

    let :download_link_hash do
      download_link.downloadKey
    end

    describe "GET 'download'" do
      let(:expected_content) { ActiveFedora::Base.find(file.id).original_file.content }

      it "and_return http success" do
        expect(controller).to receive(:send_file_headers!).with(filename: 'world.png', disposition: 'attachment', type: 'image/png')
        get :download, id: download_link_hash
        expect(response.body).to eq expected_content
        expect(response).to be_success
        expect { SingleUseLink.find_by_downloadKey!(download_link_hash) }.to raise_error ActiveRecord::RecordNotFound
      end

      context "and the key is not found" do
        before { SingleUseLink.find_by_downloadKey!(download_link_hash).destroy }

        it "returns 404 if the key is not present" do
          get :download, id: download_link_hash
          expect(response).to render_template('error/single_use_error')
        end
      end
    end

    describe "GET 'show'" do
      it "and_return http success" do
        get 'show', id: show_link_hash
        expect(response).to be_success
        expect(assigns[:presenter].id).to eq file.id
        expect { SingleUseLink.find_by_downloadKey!(show_link_hash) }.to raise_error ActiveRecord::RecordNotFound
      end

      context "and the key is not found" do
        before { SingleUseLink.find_by_downloadKey!(show_link_hash).destroy }
        it "returns 404 if the key is not present" do
          get :show, id: show_link_hash
          expect(response).to render_template('error/single_use_error')
        end
      end

      it "returns 404 on attempt to get show path with download hash" do
        get :show, id: download_link_hash
        expect(response).to render_template('error/single_use_error')
      end
    end
  end
end
