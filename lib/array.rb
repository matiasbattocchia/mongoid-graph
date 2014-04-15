class Array
  def >> obj
    delete_if do |element|
      element.eql? obj
    end
  end
end
