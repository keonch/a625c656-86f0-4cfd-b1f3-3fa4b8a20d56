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

  def sort_new(input)
    link_to "New", dogs_path(sort: "new", page: 1)
  end

  def sort_rising(input)
    link_to "Rising", dogs_path(sort: "rising", page: 1)
  end

  def next_page(input)
    link_to "Next", dogs_path(sort: input.sort_type, page: input.curr_page + 1)
  end

  def prev_page(input)
    link_to "Previous", dogs_path(sort: input.sort_type, page: input.curr_page - 1)
  end

  def delegate(dogs, sort, page)
    puts "======================================================"
    puts page
    puts sort
    puts "======================================================"
    delegated_dogs = Indexed.new(dogs)
    delegated_dogs.sort_type = sort
    delegated_dogs.curr_page = page
    delegated_dogs
  end

  class Indexed < SimpleDelegator
    attr_accessor :sort_type, :curr_page
  end
end
