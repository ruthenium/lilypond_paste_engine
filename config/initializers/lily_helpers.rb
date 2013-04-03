#require File.expand_path File.join(File.dirname(__FILE__), "..", "environment.rb")

raise Exception.new("Path to Lilypond distribution must be defined in order to work properly!") unless Lpe::Application.config.respond_to? :lilypond_path

raise Exception.new("Invalid Lilypond path!") unless File.exists?(Lpe::Application.config.lilypond_path)

require "#{Rails.root}/lib/lily_helpers.rb"