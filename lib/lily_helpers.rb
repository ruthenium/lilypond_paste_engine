require 'open3'

module LilyHelpers
  module Utility # mixin with process spawn
    def process(args)
      command, target = args[:cmd], args[:target]
      thr = Thread.new do
        res = Open3.popen3(*command) do |i,o,e,t|
          i.binmode.puts target.read
          i.close_write
          Thread.exit unless t.value.success?
          o.read
        end
        (block_given?) ? (yield res) : (res)
      end
      thr.value unless thr.join(2 * 60).nil?
    end # process
  end # module Utility

  module MXMLConverter
    extend Utility

    class << self # to use alias more comfortable
      MXML2LY = File.join(Lpe::Application.config.lilypond_path, 'bin', 'musicxml2ly')

      def process(mxml)
        super :cmd => [MXML2LY, '--output=-', '-'], :target => mxml
      end
      
      alias :convert :process
    end # class << self
  end # module MXMLConverter

  module LilypondProcessor
    extend Utility

    self::LILYPOND = File.join(Lpe::Application.config.lilypond_path, 'bin', 'lilypond')

    def self.process(ly, basename, dir)
      args = {
        target: ly,
        cmd: [LILYPOND, '-dsafe', '--png', '--pdf', "-o#{basename}", '-', :chdir => dir]
      }
      super args do
        result = Hash.new { |h, k| h[k] = [] }
        Dir.glob("#{dir}/*.{png,pdf}").sort!.each do |item|
          result[File.extname(item)[1..-1].to_sym] << item
        end
        result
      end # super args
    end # self.process
  end # LilypondProcessor

  def self.mxml_to_lilypond(mxml)
    MXMLConverter.convert(mxml)
  end

  def self.process_lilypond(ly, basename, dir)
    LilypondProcessor.process(ly, basename, dir)
  end
end # module LilyHelpers