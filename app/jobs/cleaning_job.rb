class CleaningJob    
  def perform
    Paste.destroy_all(['expires_at < ?', Time.now])
    CarrierWave.clean_cached_files!
  end
end