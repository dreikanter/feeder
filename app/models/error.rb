# == Schema Information
#
# Table name: errors
#
#  id                 :integer          not null, primary key
#  status             :integer          default("pending"), not null
#  error_class_name   :string           default(""), not null
#  file_name          :string
#  line_number        :integer
#  label              :string           default(""), not null
#  message            :string           default(""), not null
#  backtrace          :string           default([]), not null, is an Array
#  filtered_backtrace :string           default([]), not null, is an Array
#  context            :json             not null
#  occured_at         :datetime         not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_errors_on_error_class_name  (error_class_name)
#  index_errors_on_file_name         (file_name)
#  index_errors_on_occured_at        (occured_at)
#  index_errors_on_status            (status)
#

class Error < ApplicationRecord
  enum status: Enums::ErrorStatus.hash

  attr_accessor :exception

  def self.for(exception, context = {})
    new(
      status: Enums::ErrorStatus.pending,
      occured_at: context[:occured_at] || DateTime.now,
      error_class_name: exception.class.name,
      file_name: exception.backtrace_locations.first.try(:path) || '',
      line_number: exception.backtrace_locations.first.try(:lineno),
      label: exception.backtrace_locations.first.try(:label) || '',
      message: exception.try(:message) || context[:message] || exception.to_s,
      backtrace: exception.backtrace,
      filtered_backtrace: Services::ErrorBacktraceCleaner.clean(exception),
      context: context
    )
  end

  def self.dump(exception, context = {})
    self.for(exception, context).save!
  end
end
