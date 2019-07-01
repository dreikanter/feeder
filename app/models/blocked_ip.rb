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

class BlockedIP < ApplicationRecord
end
