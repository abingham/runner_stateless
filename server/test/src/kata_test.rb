require_relative 'test_base'

class KataTest < TestBase

  def self.hex_prefix
    'FB0D4'
  end

  def hex_setup
    set_image_name "#{cdf}/gcc_assert"
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'DBC', %w( kata_new is a no-op for API compatibility ) do
    kata_new
  end

  test 'DBD', %w( kata_old is a no-op for API compatibility ) do
    kata_old
  end

end