class Group < ActiveRecord::Base
  has_and_belongs_to_many :members, -> {  uniq }, class_name: 'User'
  has_many :topics
  has_many :comments, through: :topics
  belongs_to :owner, class_name: 'User'

  mount_uploader :icon, IconUploader

  def member_count
    members.count
  end

  def description
    ''
  end

  def has_member?(user)
    members.include?(user)
  end
  after_create :set_owner_membership


  def transfer(member)
    if members.include?(member)
      self.owner = member
      save!
    end
  end

  private
  def set_owner_membership
    members << owner unless members.include?(owner)
  end
end
