RSpec.shared_context "freefeed api request stubs" do
  let(:freefeed_post_id) { "f102b70e-0d7a-425a-aca9-68d4462cdea4" }
  let(:attachment_id) { "f102b70e-0d7a-425a-aca9-68d4462cdea5" }
  let(:comment_id) { "f102b70e-0d7a-425a-aca9-68d4462cdea6" }

  def stub_post_create
    stub_request(:post, "https://candy.freefeed.net/v1/posts")
      .to_return(
        headers: {"Content-Type" => "application/json"},
        body: {"posts" => {"id" => freefeed_post_id}}.to_json
      )
  end

  def stub_attachment_download
    stub_request(:get, "https://example.com/attachment.jpg")
      .to_return(
        headers: {"Content-Type" => "image/jpeg"},
        body: file_fixture("1x1.png")
      )
  end

  def stub_attachment_create
    stub_request(:post, "https://candy.freefeed.net/v1/attachments")
      .to_return(
        headers: {"Content-Type" => "application/json"},
        body: {"attachments" => {"id" => attachment_id}}.to_json
      )
  end

  def stub_comment_create
    stub_request(:post, "https://candy.freefeed.net/v1/comments")
      .to_return(
        headers: {"Content-Type" => "application/json"},
        body: {"comments" => {"id" => comment_id}}.to_json
      )
  end
end
