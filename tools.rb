module Tools
  require 'Matrix'

  ALPHABET = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

  def self.letters_matching (a_value)
    return Hash[ALPHABET.each_with_index.map { |letter, index| [letter, index+a_value.to_i]}] if a_value.to_i.between?(0,1)
    puts "Wrong value for alphabet matching"
    exit
  end

  def self.build_matrix(matrix)
    begin
      m = Matrix.empty(0,0)
      eval(matrix).each {|array| m = Matrix.rows (m.to_a << array)}
      return m if m.square?
    rescue Exception => e
      puts e
      exit
    end
  end

  def self.cipher(matrix, string, alphabet)
    dimension = self.matrix_dimension(matrix)
    puts "Dimension : #{dimension}"
    puts "Original matrix : #{matrix.inspect}"
    parts = self.format_string(string).chars.each_slice(dimension).to_a
    pairs = parts.map do |p|
      while p.length < dimension do
        p << 'A'
      end

      Matrix.column_vector(p.map {|l| alphabet[l]})
    end

    encoded_pairs = pairs.map do |p|
      (matrix*p).map { |v| v%26 }
    end

    encoded_string = encoded_pairs.map do |p|
      p.to_a.map do |l|
       alphabet.select {|let, ord| ord == l.first }.keys.first
      end.flatten
    end.flatten.join
    encoded_string.chars.each_slice(5).to_a.map(&:join).join(' ')
  end

  def self.decipher(matrix, string, alphabet)
    puts "Original matrix : #{matrix.inspect}"
    dimension = self.matrix_dimension(matrix)
    parts = self.format_string(string).chars.each_slice(dimension).to_a
    puts "Parts : #{parts.inspect}"
    adjugate_matrix = matrix.adjugate()
    puts "Adjugated matrix : #{adjugate_matrix}"
    determinant = self.inverse_determinant(matrix.determinant)
    puts "Inversed determinant : #{determinant}"
    t_matrix = adjugate_matrix * determinant
    puts "Matrix to use #{t_matrix.inspect}"
    # Matrix to array takes  line
    decoded_matrix = t_matrix.to_a.map do |line|
      line.map {|el| el%26}
    end
    decoded_matrix = Matrix.rows(decoded_matrix)

    parts = parts.map do |p|
      p.to_a.map do |l|
        alphabet.select {|let, ord| let == l }.values.first
      end
    end

    decoded_ord = parts.map do |p|
     self.decode_ngram(p, decoded_matrix)
    end

    decoded_string = decoded_ord.map do |num|
      num.map do |n|
       alphabet.select {|let, ord| ord == n }.keys.first
      end
    end.flatten.join

    decoded_string.chars.each_slice(5).to_a.map(&:join).join(' ')
  end

  def self.inverse_determinant(determinant)
    factors = [1,3,5,7,9,11,13,15,17,19,21,23,25]
    if (1.0/determinant).between?(0,1)
      factors.each do |f|
        return f if ((determinant*f)%26 == 1)
      end
    elsif (1.0/determinant).between?(-1,0)

    end
    return determinant
  end

  def self.decode_ngram(ngram, matrix)
    length = ngram.size
    if matrix.square? and matrix.row(0).size === length
      matrix.to_a.map do |row|
        row.each_with_index.inject(0) {|sum, (v, index)| sum + (v*ngram[index])} % 26
      end
    else
      puts 'Wrong matrix'
    end
  end

  def self.format_string(string)
    regexp = /[^a-zA-Z]/
    string.gsub(regexp, '').upcase
  end

  def self.matrix_dimension(matrix)
    matrix.row(0).size
  end
end