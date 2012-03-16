
#//
#// This simple model only sets data into the database
#// Return value from the @data hash
#//

class MongoSimpleModel

  def data=(in_data)
    @data = in_data
    @object_id = @data["_id"]
  end

  def get_value(key)
    return nil if @data.nil?
    @data[key]
  end

end



