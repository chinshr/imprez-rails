raise "Presentation has not been defined yet" unless defined? Presentation
class Presentation

  # E.g.
  #
  #     @presentation = Presentation::Template.new \
  #       :root       => "../templates/simple",
  #       :image_path => "/foo/bar",
  #       :html       => "index.html"
  #     
  #     @presentation.content
  #
  class Template
    attr_accessor :image_path, :root

    @@default_image_path = "/images/sample_campaign"
    @@admissible_formats = [:html, :css, :erb]

    def initialize(options)
      raise ArgumentError, "argument must be a hash" unless options.instance_of? Hash
      @image_path = options[:image_path] || @@default_image_path
      @root = options[:root] || Rails.root
      @options = options
    end

    def contents
      @contents or begin
        format = @options.keys.detect {|key| @@admissible_formats.include?(key)}
        @contents = send "load_#{format}", @options[format]
      end
    end

    alias to_s contents

    private

    def get_file_contents(path)
      File.read(File.join(root, path))
    end

    def load_html(path)
      html = Nokogiri::HTML get_file_contents(path)
      html.at_css("#impress").tap do |impress|
        ['img', 'input[type=image]'].each do |selector|
          impress.css(selector).each do |elem|
            elem["src"] = [image_path, File.basename(URI.parse(elem["src"]).path)].join("/")
          end
        end
        return impress.to_html
      end
    end

    def load_erb(path)
      get_file_contents(path)
    end

    def load_css(path)
      css = get_file_contents(path)
      css.gsub(%r{(url\(['"]?)(.*)(['"]?)\)}) do |match|
        match.gsub(/['"]/, '').gsub(/url(.*)/) do |p|
          "url(#{[image_path, File.basename(p)].join("/")}"
        end
      end
    end
  end
end