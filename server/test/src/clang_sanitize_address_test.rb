require_relative 'test_base'

class ClangSanitizeAddressTest < TestBase

  def self.hex_prefix
    'D286B'
  end

  # - - - - - - - - - - - - - - - - -

  test '0BB',
  %w( [clang,assert] clang sanitize address ) do
    in_kata_as('salmon') {
      run_cyber_dojo_sh
      assert_colour 'red'
      run_cyber_dojo_sh( {
        changed_files:{ 'hiker.c' => <<~C_SOURCE
          #include "hiker.h"
          #include <stdlib.h>

          int answer(void)
          {
              int * p = (int *)malloc(64);
              p[0] = 6;
              free(p);
              return p[0] * 7;
          }
          C_SOURCE
        }
      })
      assert_colour 'amber'
      diagnostic = 'AddressSanitizer: heap-use-after-free on address'
      assert stderr.include?(diagnostic), @json
    }
  end

end