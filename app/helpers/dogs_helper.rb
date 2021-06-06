module DogsHelper
  def dog_has_owner?
    !!@dog.owner
  end

  def user_is_dog_owner?
    @dog.owner == current_user
  end

  def user_liked_dog?
    @dog.likes.any? {|like| like.user == current_user}
  end
end
