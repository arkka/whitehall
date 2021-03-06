require 'json'

class Whitehall::Uploader::Parsers::OldUrlParser
  def self.parse(old_url, logger, line_number)
    if old_url[0] == '['
      parse_json_old_url(old_url, logger)
    elsif old_url.blank?
      []
    else
      [old_url]
    end
  end

  def self.parse_json_old_url(old_url, logger)
    JSON.parse(old_url)
  rescue JSON::ParserError => e
    logger.error "Unable to parse the old url '#{old_url}', #{e.class.name}: #{e.message}"
    []
  end
end
