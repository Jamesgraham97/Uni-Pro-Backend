class UserSerializer < ActiveModel::Serializer
    attributes :id, :display_name, :email, :created_at, :updated_at
  end