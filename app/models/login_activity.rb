# == Schema Information
#
# Table name: login_activities
#
#  id             :bigint           not null, primary key
#  scope          :string
#  strategy       :string
#  identity       :string
#  success        :boolean
#  failure_reason :string
#  user_type      :string
#  user_id        :bigint
#  context        :string
#  ip             :string
#  user_agent     :text
#  referrer       :text
#  city           :string
#  region         :string
#  country        :string
#  latitude       :float
#  longitude      :float
#  created_at     :datetime
#
class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true
end
