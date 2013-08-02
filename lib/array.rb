class Array
  def >> obj
    delete_if do |item| item.eql? obj end
  end
end
