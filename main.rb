require_relative 'Tools'
require_relative 'Matrix'

puts "Please enter the matrix you want to use to cipher your string : Array of arrays"
matrix = Tools.build_matrix(gets.chomp)
# matrix = Tools.build_matrix("[[-3,-3,-4],[0,1,1],[3,3,3]]")
puts "Please enter the string you want to proceed :"
string = gets.chomp
puts "Please enter the value you want to give to A (0 or 1) :"
alphabet = Tools.letters_matching(gets.chomp)
# alphabet = Tools.letters_matching("0")

puts "Do you want to cipher (c) or decipher (d) the string ?"
action = gets.chomp

if action == 'd'
  puts Tools.decipher(matrix, string, alphabet)
else
  puts Tools.cipher(matrix, string, alphabet)
end