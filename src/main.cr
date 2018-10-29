ENGLISH_LETTER_FREQUENCIES = [
    0.08167,
    0.01492,
    0.02782,
    0.04253,
    0.12702,
    0.02228,
    0.02015,
    0.06094,
    0.06966,
    0.00153,
    0.00772,
    0.04025,
    0.02406,
    0.06749,
    0.07507,
    0.01929,
    0.00095,
    0.05987,
    0.06327,
    0.09056,
    0.02758,
    0.00978,
    0.0236,
    0.0015,
    0.01974,
    0.00074
]

def is_letter(c)
    (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
end

def to_letter_index(c)
    if c >= 'a' && c <= 'z'
        c - 'a'
    elsif c >= 'A' && c <= 'Z'
        c - 'A'
    else
        raise "'#{c}' is not a letter"
    end
end

def cipher_char(c, n)
    return c if !is_letter(c)

    offset = c >= 'a' && c <= 'z' ? 'a' : 'A'
    rc = c - offset

    return offset + ((rc + n) % 26) 
end

def cipher(str, n)
    String.build do |s|
        str.each_char do |c|
           s << cipher_char(c, n) 
        end  
    end
end

def calculate_letter_frequencies(str)
    frequencies = Array(Float64).new(26, 0)
    total = 0
    
    str.each_char_with_index do |c, i|
        next unless is_letter(c)
        rc = to_letter_index(c)
        frequencies[rc] += 1
        total += 1
    end
    
    frequencies.map! do |x|
        x / total
    end

    frequencies
end

def distance(a, b)
    raise "Array lengths do not match" if a.size != b.size
    
    sum = 0
    a.each_with_index do |x, i|
        sum += (x - b[i]).abs
    end

    sum / a.size
end

def frequency_analysis(str)
    closest_distance = Float64::MAX
    closest_shift = 0
    
    (1..25).each do |i|
        shifted = cipher(str, i)
        shifted_frequencies = calculate_letter_frequencies shifted
        dist = distance(shifted_frequencies, ENGLISH_LETTER_FREQUENCIES)
        
        if dist < closest_distance
            closest_distance = dist
            closest_shift = i
        end
    end

    closest_shift
end

def usage
    puts "Usage: caesar <transform|frequency_analysis> [offset] <file>"
    exit
end

usage if ARGV.size == 0
usage if ARGV[0] != "transform" &&
         ARGV[0] != "crack"

begin
    case ARGV[0]
    when "transform"
        usage if ARGV.size != 3
        str = File.read(ARGV[2])
        puts cipher(str, ARGV[1].to_i)    
    when "crack"
        usage if ARGV.size != 2
        str = File.read(ARGV[1])
        shift = frequency_analysis str
        puts "#{cipher(str, shift)}\n\nKey: #{26 - shift}" 
    end
rescue
    puts "File '#{ARGV[1]}' not found"
end
