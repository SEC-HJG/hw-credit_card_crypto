# frozen_string_literal: true

require_relative 'credit_card'

# double transposition - switch rows and cols
module DoubleTranspositionCipher
  def self.generate_matrix(str)
    # rows = key[0].length
    # cols = key[1].length
    len = str.length
    cols = Math.sqrt(len).floor
    rows = (len % cols).zero? ? cols : cols + 1

    arr = Array.new(rows) { Array.new(cols) { '_' } }
    str.chars.each_with_index do |chr, index|
      arr[index / cols][index % cols] = chr
    end

    arr
  end

  # def self.swap(arr, key, back: false)
  #   # clone a arr from original one
  #   new_arr = arr.map(&:clone)
  #   key.each_with_index do |r_idx, idx|
  #     # r_idx - 1 because the input start from 1 instead of 0
  #     back == false ? new_arr[idx] = arr[r_idx - 1] : new_arr[r_idx - 1] = arr[idx]
  #   end
  #   new_arr
  # end

  def self.encrypt(document, key)
    # TODO: FILL THIS IN!
    ## Suggested steps for double transposition cipher
    # 1. find number of rows/cols such that matrix is almost square
    # 2. break plaintext into evenly sized blocks
    # enc_doc = CreditCard.from_s(document.to_s)
    # arr = generate_matrix(enc_doc.number, key)
    arr = generate_matrix(document.to_s)

    # 3. sort rows in predictibly random way using key as seed
    # row_swap_arr = swap(arr, key[0])
    row_swap_arr = arr.shuffle(random: Random.new(key))

    # 4. sort columns of each row in predictibly random way
    # col_swap_arr = swap(row_swap_arr.transpose, key[1])
    col_swap_arr = row_swap_arr.transpose.shuffle(random: Random.new(key))

    # 5. return joined cyphertext
    # enc_doc.number = col_swap_arr.transpose.reduce(&:+).reduce(&:+)
    # enc_doc.to_s
    col_swap_arr.transpose.reduce(&:+).reduce(&:+)
  end

  def self.decrypt(ciphertext, key)
    # TODO: FILL THIS IN!
    # generate matrix format
    # document = CreditCard.from_s(ciphertext)
    # arr = generate_matrix(document.number, key)
    arr = generate_matrix(ciphertext)

    # swap col first
    # col_swap_arr = swap(arr.transpose, key[1], back: true)
    col_swap_arr = arr.transpose.unshuffle(random: Random.new(key))

    # swap row
    # row_swap_arr = swap(col_swap_arr.transpose, key[0], back: true)
    row_swap_arr = col_swap_arr.transpose.unshuffle(random: Random.new(key))

    # document = row_swap_arr.reduce(&:+).reduce(&:+)
    # document.to_s
    row_swap_arr.reduce(&:+).reduce(&:+)
  end
end

# extend array obj
class Array
  def unshuffle(random:)
    transformed_order = (0...length).to_a.shuffle!(random: random)
    sort_by.with_index { |_, i| transformed_order[i] }
  end
end
