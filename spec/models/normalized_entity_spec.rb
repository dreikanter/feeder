require "rails_helper"

RSpec.describe NormalizedEntity do
  subject(:model) { described_class }

  let(:attributes) do
    {
      uid: "UID",
      link: "https://example.com",
      published_at: DateTime.parse("2023-06-16 02:00:00 +0000"),
      text: "Text",
      attachments: [],
      comments: [],
      validation_errors: []
    }
  end

  it { expect(model.new(**attributes)).to be_a(Data) }
end
