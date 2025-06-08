module DefaultHeaders
  def json_headers
    {
      "ACCEPT" => "application/json",
      "Content-Type" => "application/json"
    }
  end
end

RSpec.configure do |config|
  config.include DefaultHeaders, type: :request
end
