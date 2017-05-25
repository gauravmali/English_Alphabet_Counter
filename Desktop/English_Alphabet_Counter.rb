require 'nokogiri'
require 'open-uri'

def awesome_alphabet_counter(requestURL)
    requested_uri = Nokogiri::HTML(open(requestURL)) # using Nokogiri to parse the HTML
    alphabets_string = requested_uri.css('body').to_s # Fetching HTML's body and converting everything into String
    alphabets_hash = {}
    if ! alphabets_string.valid_encoding? # This loop works if a website is not encoded properly
        alphabets_string = alphabets_string.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
    end
    # The code below is for clean-up part: removing \n, spaces and finally choosing ONLY alphabets and ignoring numberes or special characters.
    all_alphabets_array = alphabets_string.gsub("\n",'').split("").map {|x| x[/[a-zA-Z]+/]} 
    counter = 0
    # This loop below will make a Hash of all the Alphabets (key) and their counts (value), by creating new key if not available and increasing value if one alphabet repeats.
    while counter < all_alphabets_array.length
        specific_alphabet = all_alphabets_array[counter]
        if alphabets_hash.has_key? specific_alphabet
            alphabets_hash[specific_alphabet] += 1
        else
            alphabets_hash[specific_alphabet] = 1
        end
        counter = counter + 1
    end
    reversed_alphabet_hash = alphabets_hash.sort_by {|key,value| value}.reverse # Reversing the hash so that highest value key comes first and so forth.
    # Code below is to calculate persentage of all the keys in the alphabet Hash.
    reversed_alphabet_hash.each do |alphabet,alphabet_count|
        alphabet_percentage = alphabet_count * 100/all_alphabets_array.length.to_f
        p(alphabet + "  " + alphabet_percentage.to_s + "%") if alphabet !=nil # Printing the output here.
    end
end
    
# I am passing URL here, please edit and change URL accordingly.
awesome_alphabet_counter('https://raw.githubusercontent.com/dwyl/english-words/master/words.txt')
