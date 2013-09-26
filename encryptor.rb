require 'digest'
class Encryptor	

#   def cipher
#     {'a' => 'n', 'b' => 'o', 'c' => 'p', 'd' => 'q',
#      'e' => 'r', 'f' => 's', 'g' => 't', 'h' => 'u',
#      'i' => 'v', 'j' => 'w', 'k' => 'x', 'l' => 'y',
#      'm' => 'z', 'n' => 'a', 'o' => 'b', 'p' => 'c',
#      'q' => 'd', 'r' => 'e', 's' => 'f', 't' => 'g',
#      'u' => 'h', 'v' => 'i', 'w' => 'j', 'x' => 'k',
#      'y' => 'l', 'z' => 'm', ' ' => ' '}
#   end

  def pass_check
    puts "Password:"
    password = gets.chomp
    crypt_pass = Digest::MD5.hexdigest(password)
    if File.read("config.txt").include? (crypt_pass) 
      puts "Authorized, please continue."
    else
      abort("Access Denied")
    end

  end

  def supported_characters
    (' '..'z').to_a 
  end

  def cipher(rotate)
     rotated_characters = supported_characters.rotate(rotate)
     stupid_hash = Hash[supported_characters.zip(rotated_characters)]
     stupid_hash.store("\n", "\n")
     stupid_hash
  end

  def encrypt_letter(letter, rotate)
    cipher_rotate = cipher(rotate)
    cipher_rotate[letter]
  end

  def encrypt(string = nil, rotate = 13)
    if string.nil?
    puts "What would you like to encrypt?"
    string = gets.chomp
    puts "How many rotations?"
    rotate = gets.chomp.to_i
    end

    letters = string.split("")
    results = letters.collect do |letter|
      encrypt_letter(letter, rotate)
    end

    @end_results = results.join
  end

  def decrypt(string = nil, rotate = 13)
    if string.nil?
    puts "What would you like to decrypt?"
    string = gets.chomp
    puts "How many rotations?"
    rotate = gets.chomp.to_i
    end

    encrypt(string, -(rotate)) 
  end

  def encrypt_file(filename, rotate)
  file = File.open(filename, "r")
  input = file.read
  encrypt(input, rotate)
    if filename.include?('.encrypted')
      output_filename = filename.gsub('.encrypted', '.decrypted')  
    else 
      output_filename = filename + ".encrypted"
    end

  File.open(output_filename, "w") do |file|
    file.write(@end_results)
    
    end
  end

  def decrypt_file(filename, rotate)
    encrypt_file(filename, -rotate)
  end

  def crack(message)
    supported_characters.count.times.collect do |attempt|
      decrypt(message,attempt)
    end
  end

  # def adv_encrypt(string, rotate = [1, 3, 5])
  #     letters = string.split("")
  #     count = 0
  
  # end


end

e = Encryptor.new
e.pass_check
