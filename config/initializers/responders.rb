# custom responder for flash notice disabling.

class PasteResponder < ActionController::Responder
  include Responders::HttpCacheResponder
end