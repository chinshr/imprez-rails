require "active_support"
require "test/unit"
require "nokogiri"

class Presentation
end

require File.expand_path("../../../lib/presentation/template", __FILE__)

class PresentationTemplateTest < ActiveSupport::TestCase

  def setup
    @root          = File.expand_path("../../../templates/sample", __FILE__)
    @html_template = "index.html"
    # @erb_template  = "footer.erb"
    @css_template  = "css/impress-demo.css"
  end

  test "should raise an error if the constructor agument is not a hash" do
    assert_raises ArgumentError do
      Presentation::Template.new "file/path"
    end
  end

  test "should load an HTML template from the file sytem" do
    template = Presentation::Template.new :html => @html_template, :root => @root
    assert_not_nil template.contents
    assert_match(/<div/, template.contents)
  end

  test "should load just the contents of the body tag" do
    template = Presentation::Template.new :html => @html_template, :root => @root
    refute template.contents.match(/\<html/), "should not have <html"
    refute template.contents.match(/\<head/), "should not have <head"
    refute template.contents.match(/\<body/), "should not have <body"
  end

  test "should replace HTML image paths with production image paths" do
    template = Presentation::Template.new :image_path => "/foo/bar", :html => "", :root => @root
    template.expects(:get_file_contents).returns <<-EOHTML
      <div id="impress">
        <img src="/hello/world.png">hello!</a>
      </div>
    EOHTML
    assert template.contents.match(/src="\/foo\/bar/)
  end

=begin
  test "should load an ERB template from the filesystem" do
    template = Presentation::Template.new :erb => @erb_template, :root => @root
    assert_not_nil template.contents
    assert template.contents.match(/<p>/), "should have contents"
  end
=end

  test "should load a CSS template from the filesystem" do
    template = Presentation::Template.new :css => @css_template, :root => @root
    assert_not_nil template.contents
    assert template.contents.match(/background/), "should have contents"
  end

  test "should replace CSS image paths with production image paths" do
    template = Presentation::Template.new :image_path => "/foo/bar", :css => "", :root => @root
    template.expects(:get_file_contents).returns <<-EOCSS
      #foo {
        background transparent url(/hello/world/steps.gif) top left no-repeat;
      }
    EOCSS
    assert template.contents.match(/\/foo\/bar\/steps.gif/), "should substitute image path"
  end

  test "should replace CSS image paths with production image paths when image paths are quoted" do
    template = Presentation::Template.new :image_path => "/foo/bar", :css => "", :root => @root
    template.expects(:get_file_contents).returns <<-EOCSS
      #foo {
        background transparent url("/hello/world/steps.gif") top left no-repeat;
      }
    EOCSS
    assert template.contents.match(/\/foo\/bar\/steps.gif/), "should substitute image path with quotes"
  end
end
