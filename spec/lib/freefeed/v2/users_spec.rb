require "rails_helper"

RSpec.describe Freefeed::V2::Users do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  describe "#whoami" do
    it "retrieves user information" do
      stub_request(:get, "https://example.com/v2/users/whoami").to_return(status: 200)
      response = client.whoami

      expect(response.status).to eq(200)
    end
  end

  describe "#blocked_by_me" do
    it "retrieves blocked users" do
      stub_request(:get, "https://example.com/v2/users/blockedByMe").to_return(status: 200)
      response = client.blocked_by_me

      expect(response.status).to eq(200)
    end
  end

  describe "#unread_directs_number" do
    it "retrieves the number of unread directs" do
      stub_request(:get, "https://example.com/v2/users/getUnreadDirectsNumber").to_return(status: 200)
      response = client.unread_directs_number

      expect(response.status).to eq(200)
    end
  end

  describe "#unread_notifications_number" do
    it "retrieves the number of unread notifications" do
      stub_request(:get, "https://example.com/v2/users/getUnreadNotificationsNumber").to_return(status: 200)
      response = client.unread_notifications_number

      expect(response.status).to eq(200)
    end
  end

  describe "#mark_all_directs_as_read" do
    it "marks all directs as read" do
      stub_request(:get, "https://example.com/v2/users/markAllDirectsAsRead").to_return(status: 200)
      response = client.mark_all_directs_as_read

      expect(response.status).to eq(200)
    end
  end

  describe "#mark_all_notifications_as_read" do
    it "marks all notifications as read" do
      stub_request(:post, "https://example.com/v2/users/markAllNotificationsAsRead").to_return(status: 200)
      response = client.mark_all_notifications_as_read

      expect(response.status).to eq(200)
    end
  end
end
