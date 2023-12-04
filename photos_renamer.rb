# General Idea

# Split the string into individual photos (new line according footnotes)
# Map individual photos/split name, where, time (comma)
# Sort by city and time? Viceversa maybe. Sort twice? group first maybe? 
# Get the largest number of photos per location
# rename the photos and somehow add the 0 in front with string subs or something similar
# return in the original order somehow. Maybe don't save the grouped/sorted array/s or use index to find again?

def solution(s)
    photos_array = s.split("\n")
    mapped_photos = map_photos(photos_array)
    grouped_photos = sort_photos(mapped_photos)
    largest_digits = largest_digits(grouped_photos)
    renamed_photos = rename_photos(mapped_photos, grouped_photos, largest_digits)
    renamed_photos.join("\n")
end

def map_photos(photos)
    photos.map do |photo|
        name, city, date = photo.split(", ")
        {
            name: name,
            city: city,
            date: date
        }
    end
end

def sort_photos(mapped_photos)
    photos_by_city = mapped_photos.group_by { |photo| photo[:city] }
    photos_by_city.each { |city, photos_array| photos_array.sort_by! { |photo| photo[:date] } }
end

def largest_digits(grouped_photos)
    largest_digit = {}

    grouped_photos.each do |city, photos_array|
        largest_digit[city] = photos_array.length.digits.length
    end

    largest_digit
end

def rename_photos(mapped_photos, grouped_photos, largest_digits)
    mapped_photos.map do |photo|
        city = photo[:city]
        leading_zero = largest_digits[city]
        number = (grouped_photos[city].index(photo) + 1).to_s.rjust(leading_zero, '0')
        extension = photo[:name].split('.').last
        "#{city}#{number}.#{extension}"
    end
end

#TEST

def test_rename_photos_output(string_input, expected_output)
    if expected_output == solution(string_input)
      "Output matches"
    else
      "Unexpected Output"
    end
end

example_string = "photo.jpg, Krakow, 2013-09-05 14:08:15
Mike.png, London, 2015-06-20 15:13:22
myFriends.png, Krakow, 2013-09-05 14:07:13
Eiffel.jpg, Florianopolis, 2015-07-23 08:03:02
pisatower.jpg, Florianopolis, 2015-07-22 23:59:59
BOB.jpg, London, 2015-08-05 00:02:03
notredame.png, Florianopolis, 2015-09-01 12:00:00
me.jpg, Krakow, 2013-09-06 15:40:22
a.png, Krakow, 2016-02-13 13:33:50
b.jpg, Krakow, 2016-01-02 15:12:22
c.jpg, Krakow, 2016-01-02 14:34:30
d.jpg, Krakow, 2016-01-02 15:15:01
e.png, Krakow, 2016-01-02 09:49:09
f.png, Krakow, 2016-01-02 10:55:32
g.jpg, Krakow, 2016-02-29 22:13:11"

expected_output= "Krakow02.jpg
London1.png
Krakow01.png
Florianopolis2.jpg
Florianopolis1.jpg
London2.jpg
Florianopolis3.png
Krakow03.jpg
Krakow09.png
Krakow07.jpg
Krakow06.jpg
Krakow08.jpg
Krakow04.png
Krakow05.png
Krakow10.jpg"

puts "*************** SOLUTION ***************\n"

puts solution(example_string)

puts "\n*************** TEST ***************\n"

puts test_rename_photos_output(example_string, expected_output)
