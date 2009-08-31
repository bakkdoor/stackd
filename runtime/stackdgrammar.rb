module Stackd
  include Treetop::Runtime

  def root
    @root || :program
  end

  def _nt_program
    start_index = index
    if node_cache[:program].has_key?(index)
      cached = node_cache[:program][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1 = index
      r2 = _nt_comment
      if r2
        r1 = r2
      else
        r3 = _nt_expression
        if r3
          r1 = r3
        else
          @index = i1
          r1 = nil
        end
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(Program,input, i0...index, s0)

    node_cache[:program][start_index] = r0

    r0
  end

  module Expression0
    def terminal
      elements[2]
    end

  end

  def _nt_expression
    start_index = index
    if node_cache[:expression].has_key?(index)
      cached = node_cache[:expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      r2 = _nt_space
      if r2
        s1 << r2
      else
        break
      end
    end
    r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        i4 = index
        r5 = _nt_comment
        if r5
          r4 = r5
        else
          r6 = _nt_atom
          if r6
            r4 = r6
          else
            @index = i4
            r4 = nil
          end
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      if s3.empty?
        @index = i3
        r3 = nil
      else
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      end
      s0 << r3
      if r3
        r7 = _nt_terminal
        s0 << r7
        if r7
          s8, i8 = [], index
          loop do
            r9 = _nt_space
            if r9
              s8 << r9
            else
              break
            end
          end
          r8 = instantiate_node(SyntaxNode,input, i8...index, s8)
          s0 << r8
        end
      end
    end
    if s0.last
      r0 = instantiate_node(Expression,input, i0...index, s0)
      r0.extend(Expression0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:expression][start_index] = r0

    r0
  end

  module Comment0
  end

  module Comment1
  end

  def _nt_comment
    start_index = index
    if node_cache[:comment].has_key?(index)
      cached = node_cache[:comment][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      r2 = _nt_space
      if r2
        s1 << r2
      else
        break
      end
    end
    r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    s0 << r1
    if r1
      if has_terminal?("!", false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("!")
        r3 = nil
      end
      s0 << r3
      if r3
        s4, i4 = [], index
        loop do
          i5, s5 = index, []
          i6 = index
          if has_terminal?('\G[\\n]', true, index)
            r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r7 = nil
          end
          if r7
            r6 = nil
          else
            @index = i6
            r6 = instantiate_node(SyntaxNode,input, index...index)
          end
          s5 << r6
          if r6
            if index < input_length
              r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("any character")
              r8 = nil
            end
            s5 << r8
          end
          if s5.last
            r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
            r5.extend(Comment0)
          else
            @index = i5
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        s0 << r4
        if r4
          if has_terminal?('\G[\\n]', true, index)
            r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r10 = nil
          end
          if r10
            r9 = r10
          else
            r9 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r9
        end
      end
    end
    if s0.last
      r0 = instantiate_node(Comment,input, i0...index, s0)
      r0.extend(Comment1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:comment][start_index] = r0

    r0
  end

  module Atom0
    def val
      elements[1]
    end

  end

  def _nt_atom
    start_index = index
    if node_cache[:atom].has_key?(index)
      cached = node_cache[:atom][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      r2 = _nt_space
      if r2
        s1 << r2
      else
        break
      end
    end
    r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
    s0 << r1
    if r1
      i3 = index
      r4 = _nt_datum
      if r4
        r3 = r4
      else
        r5 = _nt_identifier
        if r5
          r3 = r5
        else
          @index = i3
          r3 = nil
        end
      end
      s0 << r3
      if r3
        s6, i6 = [], index
        loop do
          r7 = _nt_space
          if r7
            s6 << r7
          else
            break
          end
        end
        r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
        s0 << r6
      end
    end
    if s0.last
      r0 = instantiate_node(Atom,input, i0...index, s0)
      r0.extend(Atom0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:atom][start_index] = r0

    r0
  end

  def _nt_datum
    start_index = index
    if node_cache[:datum].has_key?(index)
      cached = node_cache[:datum][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_array
    if r1
      r0 = r1
    else
      r2 = _nt_boolean
      if r2
        r0 = r2
      else
        r3 = _nt_integer
        if r3
          r0 = r3
        else
          r4 = _nt_float
          if r4
            r0 = r4
          else
            r5 = _nt_string
            if r5
              r0 = r5
            else
              r6 = _nt_quotation
              if r6
                r0 = r6
              else
                r7 = _nt_symbol
                if r7
                  r0 = r7
                else
                  r8 = _nt_regex
                  if r8
                    r0 = r8
                  else
                    r9 = _nt_hash
                    if r9
                      r0 = r9
                    else
                      @index = i0
                      r0 = nil
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    node_cache[:datum][start_index] = r0

    r0
  end

  module Boolean0
  end

  def _nt_boolean
    start_index = index
    if node_cache[:boolean].has_key?(index)
      cached = node_cache[:boolean][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    i1 = index
    if has_terminal?("t", false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("t")
      r2 = nil
    end
    if r2
      r1 = r2
    else
      if has_terminal?("f", false, index)
        r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("f")
        r3 = nil
      end
      if r3
        r1 = r3
      else
        @index = i1
        r1 = nil
      end
    end
    s0 << r1
    if r1
      s4, i4 = [], index
      loop do
        r5 = _nt_space
        if r5
          s4 << r5
        else
          break
        end
      end
      if s4.empty?
        @index = i4
        r4 = nil
      else
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
      end
      s0 << r4
    end
    if s0.last
      r0 = instantiate_node(Boolean,input, i0...index, s0)
      r0.extend(Boolean0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:boolean][start_index] = r0

    r0
  end

  module Integer0
  end

  module Integer1
  end

  def _nt_integer
    start_index = index
    if node_cache[:integer].has_key?(index)
      cached = node_cache[:integer][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if has_terminal?("-", false, index)
      r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("-")
      r3 = nil
    end
    if r3
      r2 = r3
    else
      r2 = instantiate_node(SyntaxNode,input, index...index)
    end
    s1 << r2
    if r2
      if has_terminal?("0", false, index)
        r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("0")
        r4 = nil
      end
      s1 << r4
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Integer0)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r0 = r1
      r0.extend(Integer)
    else
      i5, s5 = index, []
      if has_terminal?("-", false, index)
        r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("-")
        r7 = nil
      end
      if r7
        r6 = r7
      else
        r6 = instantiate_node(SyntaxNode,input, index...index)
      end
      s5 << r6
      if r6
        if has_terminal?('\G[1-9]', true, index)
          r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          r8 = nil
        end
        s5 << r8
        if r8
          s9, i9 = [], index
          loop do
            if has_terminal?('\G[0-9]', true, index)
              r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              r10 = nil
            end
            if r10
              s9 << r10
            else
              break
            end
          end
          r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
          s5 << r9
        end
      end
      if s5.last
        r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        r5.extend(Integer1)
      else
        @index = i5
        r5 = nil
      end
      if r5
        r0 = r5
        r0.extend(Integer)
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:integer][start_index] = r0

    r0
  end

  module Float0
  end

  def _nt_float
    start_index = index
    if node_cache[:float].has_key?(index)
      cached = node_cache[:float][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?("-", false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("-")
      r2 = nil
    end
    if r2
      r1 = r2
    else
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        if has_terminal?('\G[0-9]', true, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      if s3.empty?
        @index = i3
        r3 = nil
      else
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      end
      s0 << r3
      if r3
        if has_terminal?(".", false, index)
          r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(".")
          r5 = nil
        end
        s0 << r5
        if r5
          s6, i6 = [], index
          loop do
            if has_terminal?('\G[0-9]', true, index)
              r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              r7 = nil
            end
            if r7
              s6 << r7
            else
              break
            end
          end
          if s6.empty?
            @index = i6
            r6 = nil
          else
            r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
          end
          s0 << r6
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Float0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:float][start_index] = r0

    r0
  end

  module String0
    def string_val
      elements[1]
    end

  end

  def _nt_string
    start_index = index
    if node_cache[:string].has_key?(index)
      cached = node_cache[:string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('"', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_string_char
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
      if r2
        if has_terminal?('"', false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r4 = nil
        end
        s0 << r4
      end
    end
    if s0.last
      r0 = instantiate_node(StackdString,input, i0...index, s0)
      r0.extend(String0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:string][start_index] = r0

    r0
  end

  module StringChar0
    def char
      elements[1]
    end
  end

  module StringChar1
    def value
      self.char.text_value
    end
  end

  def _nt_string_char
    start_index = index
    if node_cache[:string_char].has_key?(index)
      cached = node_cache[:string_char][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    i1 = index
    if has_terminal?('"', false, index)
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r2 = nil
    end
    if r2
      r1 = nil
    else
      @index = i1
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      if index < input_length
        r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("any character")
        r3 = nil
      end
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(StringChar0)
      r0.extend(StringChar1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:string_char][start_index] = r0

    r0
  end

  module Quotation0
    def atoms
      elements[1]
    end

  end

  def _nt_quotation
    start_index = index
    if node_cache[:quotation].has_key?(index)
      cached = node_cache[:quotation][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?("[", false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("[")
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_atom
        if r3
          s2 << r3
        else
          break
        end
      end
      if s2.empty?
        @index = i2
        r2 = nil
      else
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      end
      s0 << r2
      if r2
        if has_terminal?("]", false, index)
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("]")
          r4 = nil
        end
        s0 << r4
      end
    end
    if s0.last
      r0 = instantiate_node(Quotation,input, i0...index, s0)
      r0.extend(Quotation0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:quotation][start_index] = r0

    r0
  end

  module Regex0
  end

  module Regex1
    def val
      elements[1]
    end

  end

  def _nt_regex
    start_index = index
    if node_cache[:regex].has_key?(index)
      cached = node_cache[:regex][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('/', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('/')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        i4 = index
        if has_terminal?('/', false, index)
          r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('/')
          r5 = nil
        end
        if r5
          r4 = nil
        else
          @index = i4
          r4 = instantiate_node(SyntaxNode,input, index...index)
        end
        s3 << r4
        if r4
          if index < input_length
            r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r6 = nil
          end
          s3 << r6
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(Regex0)
        else
          @index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
      if r2
        if has_terminal?('/', false, index)
          r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('/')
          r7 = nil
        end
        s0 << r7
      end
    end
    if s0.last
      r0 = instantiate_node(Regex,input, i0...index, s0)
      r0.extend(Regex1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:regex][start_index] = r0

    r0
  end

  module Array0
    def items
      elements[2]
    end

  end

  def _nt_array
    start_index = index
    if node_cache[:array].has_key?(index)
      cached = node_cache[:array][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('#(', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('#(')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_space
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
      if r2
        s4, i4 = [], index
        loop do
          r5 = _nt_atom
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        s0 << r4
        if r4
          s6, i6 = [], index
          loop do
            r7 = _nt_space
            if r7
              s6 << r7
            else
              break
            end
          end
          r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
          s0 << r6
          if r6
            if has_terminal?(')', false, index)
              r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(')')
              r8 = nil
            end
            s0 << r8
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(Array,input, i0...index, s0)
      r0.extend(Array0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:array][start_index] = r0

    r0
  end

  module Hash0
    def entry
      elements[1]
    end
  end

  module Hash1
    def entries
      elements[2]
    end

  end

  def _nt_hash
    start_index = index
    if node_cache[:hash].has_key?(index)
      cached = node_cache[:hash][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('{{', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('{{')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_space
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
      if r2
        s4, i4 = [], index
        loop do
          i5, s5 = index, []
          r7 = _nt_space
          if r7
            r6 = r7
          else
            r6 = instantiate_node(SyntaxNode,input, index...index)
          end
          s5 << r6
          if r6
            r8 = _nt_hash_entry
            s5 << r8
          end
          if s5.last
            r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
            r5.extend(Hash0)
          else
            @index = i5
            r5 = nil
          end
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
        s0 << r4
        if r4
          s9, i9 = [], index
          loop do
            r10 = _nt_space
            if r10
              s9 << r10
            else
              break
            end
          end
          r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
          s0 << r9
          if r9
            if has_terminal?('}}', false, index)
              r11 = instantiate_node(SyntaxNode,input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure('}}')
              r11 = nil
            end
            s0 << r11
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(Hashtable,input, i0...index, s0)
      r0.extend(Hash1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:hash][start_index] = r0

    r0
  end

  module HashEntry0
    def key
      elements[0]
    end

    def val
      elements[2]
    end
  end

  def _nt_hash_entry
    start_index = index
    if node_cache[:hash_entry].has_key?(index)
      cached = node_cache[:hash_entry][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_atom
    s0 << r1
    if r1
      if has_terminal?('=>', false, index)
        r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure('=>')
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_atom
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(HashEntry,input, i0...index, s0)
      r0.extend(HashEntry0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:hash_entry][start_index] = r0

    r0
  end

  module Symbol0
    def identifier
      elements[1]
    end
  end

  module Symbol1
    def symbol_name
      elements[1]
    end
  end

  def _nt_symbol
    start_index = index
    if node_cache[:symbol].has_key?(index)
      cached = node_cache[:symbol][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?(':', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(':')
      r1 = nil
    end
    s0 << r1
    if r1
      i2, s2 = index, []
      i3 = index
      if has_terminal?(':', false, index)
        r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(':')
        r4 = nil
      end
      if r4
        r3 = nil
      else
        @index = i3
        r3 = instantiate_node(SyntaxNode,input, index...index)
      end
      s2 << r3
      if r3
        r5 = _nt_identifier
        s2 << r5
      end
      if s2.last
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        r2.extend(Symbol0)
      else
        @index = i2
        r2 = nil
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(Symbol,input, i0...index, s0)
      r0.extend(Symbol1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:symbol][start_index] = r0

    r0
  end

  module Identifier0
  end

  def _nt_identifier
    start_index = index
    if node_cache[:identifier].has_key?(index)
      cached = node_cache[:identifier][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1, s1 = index, []
      i2 = index
      r3 = _nt_delimiter
      if r3
        r2 = nil
      else
        @index = i2
        r2 = instantiate_node(SyntaxNode,input, index...index)
      end
      s1 << r2
      if r2
        if index < input_length
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("any character")
          r4 = nil
        end
        s1 << r4
      end
      if s1.last
        r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
        r1.extend(Identifier0)
      else
        @index = i1
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(Identifier,input, i0...index, s0)
    end

    node_cache[:identifier][start_index] = r0

    r0
  end

  def _nt_space
    start_index = index
    if node_cache[:space].has_key?(index)
      cached = node_cache[:space][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?('\G[\\s\\n\\r\\t]', true, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:space][start_index] = r0

    r0
  end

  def _nt_paren
    start_index = index
    if node_cache[:paren].has_key?(index)
      cached = node_cache[:paren][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?('\G[\\(\\)\\[\\]]', true, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:paren][start_index] = r0

    r0
  end

  def _nt_delimiter
    start_index = index
    if node_cache[:delimiter].has_key?(index)
      cached = node_cache[:delimiter][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_paren
    if r1
      r0 = r1
    else
      r2 = _nt_space
      if r2
        r0 = r2
      else
        r3 = _nt_terminal
        if r3
          r0 = r3
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:delimiter][start_index] = r0

    r0
  end

  def _nt_terminal
    start_index = index
    if node_cache[:terminal].has_key?(index)
      cached = node_cache[:terminal][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?(';', false, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(';')
      r0 = nil
    end

    node_cache[:terminal][start_index] = r0

    r0
  end

end

class StackdParser < Treetop::Runtime::CompiledParser
  include Stackd
end

