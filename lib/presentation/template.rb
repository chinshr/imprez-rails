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

    # Return all stylesheet references, local only if true is passed.
    def stylesheets(local = false)
      send "#{local ? "local_" : ""}asset_references", "head link", "href", "rel", "stylesheet"
    end

    # Return all script references, local only if true is passed.
    def scripts(local = false)
      send "#{local ? "local_" : ""}asset_references", "script", "src"
    end

    def inline(selector = "style")
      inline_collector(selector)
    end

    def file_location(path)
      File.join(root, path)
    end
    
    def get_file_contents(path)
      File.read(file_location(path))
    end
    
    def uri?(string)
      !!string.match(/^(http:|https:)/)
    end

    def html?
      :html == @options.keys.detect {|key| @@admissible_formats.include?(key)}
    end

    private

    def local_asset_references(tag, target, rel = nil, comp = nil)
      assets(tag, target, rel, comp).select {|ref| !uri?(ref) && File.exist?(file_location(ref))}
    end

    def asset_references(tag, target, rel = nil, comp = nil)
      result = []
      if html?
        dom = dom(@options[:html])
        references = dom.css(tag).select {|el| el.attr(target)}
        references.each do |el|
          if rel && comp 
            result.push(el.attr(target)) if el.attr(rel) == comp
          else
            result.push(el.attr(target))
          end
        end
      end
      result
    end
    
    def inline_collector(selector)
      dom(@options[:html]).css(selector).map(&:inner_html).reject(&:empty?) if html?
    end

    def dom(path)
      @dom or begin
        @dom = Nokogiri::HTML get_file_contents(path)
      end
    end

    def load_html(path)
      dom(path).at_css("#impress").tap do |impress|
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