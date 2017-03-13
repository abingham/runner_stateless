require 'minitest/autorun'

class HexMiniTest < MiniTest::Test

  @@args = (ARGV.sort.uniq - ['--']).map(&:upcase) # eg 2E4
  @@seen_hex_ids = []

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.test(hex_suffix, *lines, &test_block)
    hex_id = checked_hex_id(hex_suffix, lines)
    if @@args == [] || @@args.any?{ |arg| hex_id.include?(arg) }
      execute_around = lambda {
        _hex_setup_caller(hex_id)
        begin
          self.instance_eval &test_block
        ensure
          _hex_teardown_caller
        end
      }
      proposition = lines.join(space = ' ')
      name = "hex '#{hex_suffix}',\n'#{proposition}'"
      define_method("test_\n#{name}".to_sym, &execute_around)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.checked_hex_id(hex_suffix, lines)
    method = 'def self.hex_prefix'
    pointer = ' ' * method.index('.') + '!'
    pointee = (['',pointer,method,'','']).join("\n")
    pointer.prepend("\n\n")
    fail "#{pointer}missing#{pointee}" unless respond_to?(:hex_prefix)
    fail "#{pointer}empty#{pointee}" if hex_prefix == ''
    fail "#{pointer}not hex#{pointee}" unless hex_prefix =~ /^[0-9A-F]+$/

    method = "test '#{hex_suffix}',"
    pointer = ' ' * method.index("'") + '!'
    proposition = lines.join(space = ' ')
    pointee = ['',pointer,method,"'#{proposition}'",'',''].join("\n")
    hex_id = hex_prefix + hex_suffix
    pointer.prepend("\n\n")
    fail "#{pointer}empty#{pointee}" if hex_suffix == ''
    fail "#{pointer}not hex#{pointee}" unless hex_suffix =~ /^[0-9A-F]+$/
    fail "#{pointer}duplicate#{pointee}" if @@seen_hex_ids.include?(hex_id)
    @@seen_hex_ids << hex_id
    hex_id
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def _hex_setup_caller(hex_id)
    @_hex_test_id = hex_id
    hex_setup
  end

  def _hex_teardown_caller
    hex_teardown
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def hex_setup; end
  def hex_teardown; end

  # - - - - - - - - - - - - - - - - - - - - - -

  def test_id
    @_hex_test_id
  end

end
