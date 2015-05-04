MarkdownRails.configure do |config|
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
    :fenced_code_blocks => true,
    :autolink => true, 
    :tables => true, 
    :no_intra_emphasis => true,
    :strikethrough => true,
    :highlight => true 
    )
  config.render do |markdown_source|
    markdown.render(markdown_source)
  end
end