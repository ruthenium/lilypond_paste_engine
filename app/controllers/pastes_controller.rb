class PastesController < InheritedResources::Base
  include InheritedResources::DSL

  defaults :finder => :find_by_visible_id!
  actions :new, :show, :create
  
  respond_to :html
  respond_to :json, :only => :show
  self.responder = PasteResponder # disable flash notice

  show! do |format| # GET /pastes/:id
    @paste.viewed!
    format.json { render :json => @paste.as_json(params[:links] ? :links : :status) }
  end

  create! do |success, failure| # POST /pastes
    success.html do
      Delayed::Job.enqueue PasteJob.new(@paste.id), :queue => 'paste-processing'
      redirect_to @paste
    end # success.html
  end # create!
end # PastesController
