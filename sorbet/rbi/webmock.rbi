# typed: true
# This is an RBI file for the webmock gem

module WebMock
  sig { params(method: Symbol, uri: String).returns(WebMock::RequestStub) }
  def self.stub_request(method, uri); end

  class RequestStub
    sig { params(body: T.untyped, headers: T.untyped).returns(WebMock::RequestStub) }
    def with(body: nil, headers: nil); end

    sig { params(status: Integer, body: String, headers: T.untyped).returns(WebMock::RequestStub) }
    def to_return(status:, body:, headers: nil); end
  end
end
