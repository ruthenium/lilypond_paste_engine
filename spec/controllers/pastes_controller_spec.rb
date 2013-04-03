require 'spec_helper'

describe PastesController do

  describe "GET new" do
    it "renders the :new template" do
      get :new
      response.should be_success
      response.should render_template :new
    end
  end

  describe "GET show" do
    before :all do
      @p = FactoryGirl.create :paste_with_lilypond_text, :valid => true
    end

    after :all do
      Paste.destroy_all
      @p = nil
    end

    it "gets the paste if it exists" do
      get :show, :id => @p.visible_id
      assigns(:paste).should_not be_nil
      assigns(:paste).should_not be_new_record
      assigns(:paste).visible_id.should == @p.visible_id
      assigns(:paste).id.should == @p.id
      response.should be_success
    end

    it "sends :viewed! message for existing paste" do
      Paste.any_instance.should_receive(:viewed!).once.and_call_original
      get :show, :id => @p.visible_id
      assigns(:paste).should_not be_nil
      response.should be_success
    end

    context "when html format of the response expected" do
      it "renders the :show template" do
        get :show, :id => @p.visible_id
        assigns(:paste).should_not be_nil
        assigns(:paste).id.should == @p.id
        response.should be_success
        response.should render_template :show
      end

      it "returns 404 if the paste doesn't exist" do
        Paste.any_instance.should_not_receive :viewed!
        lambda { get :show, :id => 'does-not-exist' }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when json format of the response expected" do
      it "gets the paste if it exists and renders json with links to a paste if '?links' in GET params" do
        get :show, :id => @p.visible_id, :format => :json, :links => true

        json_data = {
          id:       @p.visible_id,
          lilypond: @p.lilypond.url,
          mxml:     @p.mxml.url,
          pdf:      @p.pdf.url,
          images:   @p.images.map {|i| i.png.url }
        }.to_json
          
        response.should be_success
        json_data.should == response.body
      end

      it "gets the paste if it exists and renders json with status info only if '?links' NOT in GET params" do
        get :show, :id => @p.visible_id, :format => :json

        json_data = {
          id:        @p.visible_id,
          processed: @p.processed?,
          success:   @p.proc_success?
        }.to_json

        response.should be_success
        json_data.should == response.body
      end

      it "returns 404 if the paste doesn't exist" do
          Paste.any_instance.should_not_receive :viewed!
          lambda {
            get :show, :id => 'does-not-exist', :format => :json
          }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end # context
  end # GET show

  describe "POST create" do
    before :all do
      Paste.destroy_all
    end

    after :all do
      Delayed::Job.destroy_all
      Paste.destroy_all
    end

    context "when valid data for creating a Paste given" do
      before :each do
        @delayed_jobs_count = Delayed::Job.count
        @pastes_count = Paste.count
        @attrs = FactoryGirl.attributes_for :paste_with_lilypond_text, :valid => true
      end

      it "creates a new paste and redirects to it" do
        Delayed::Job.should_receive(:enqueue).with(kind_of(PasteJob),
          :queue => "paste-processing").once.and_call_original # delayed job

        post :create, :paste => @attrs
        # need test a mxml too
        
        assigns(:paste).should be_an_instance_of(Paste)
        assigns(:paste).lilypond_text.should == @attrs[:lilypond_text]
        assigns(:paste).expires_at.should_not be_nil
        assigns(:paste).should be_valid
        Paste.count.should == (@pastes_count + 1)

        Delayed::Job.count.should == (@delayed_jobs_count + 1)
        response.should redirect_to(assigns(:paste))
      end
    end # context

    context "when invalid data for creating a Paste given" do
      it "renders the new page with validation errors" do
        Delayed::Job.should_not_receive :enqueue

        post :create, :paste => {}

        assigns(:paste).should be_a_new(Paste)
        assigns(:paste).should be_new_record
        assigns(:paste).should_not be_valid
        assigns(:paste).errors.should_not be_empty

        response.should_not redirect_to(assigns(:paste))
        response.should render_template(:new)
      end
    end # context
  end # POST
end # controller