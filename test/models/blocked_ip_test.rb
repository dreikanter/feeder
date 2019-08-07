# == Schema Information
#
# Table name: blocked_ips
#
#  id         :bigint           not null, primary key
#  ip         :inet             not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_blocked_ips_on_ip  (ip) UNIQUE
#

require 'test_helper'

class BlockedIPTest < ActiveSupport::TestCase
  def blocked_ip
    @blocked_ip ||= BlockedIP.new
  end

  def test_valid
    assert blocked_ip.valid?
  end

  # TODO
end
