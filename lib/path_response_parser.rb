class PathResponseParser
  def initialize(path)
    @path = path

    parse
  end

  def parse
    if root_path?
      handle_homepage_response
    elsif File.exist?(file_path)
      handle_file_response
    else
      handle_404_response
    end

    self
  end

  attr_reader :status_code, :content

  private

  def handle_homepage_response
    @content = File.binread('index.html')
    @status_code = 200
  end

  def handle_file_response
    @content = if File.executable?(file_path)
                 `#{file_path}`
               else
                 File.binread(file_path)
               end
    @status_code = 200
  end

  def handle_404_response
    @content = 'File not found'
    @status_code = 404
  end

  def file_path
    (Dir.getwd + @path).gsub!(/\.+/, '.')
  end

  def root_path?
    @path.nil?
  end
end
