require 'csv'
require 'date'

def read_csv(filename)
  @parsed_array = []

  CSV.foreach(filename, {headers: true, header_converters: :symbol, encoding: "UTF-8"}) do |row|
    row_array = []

    timestamp = row[:timestamp]
    address = row[:address]
    zip = row [:zip]
    full_name = row[:fullname]
    foo_duration = row[:fooduration]
    bar_duration = row[:barduration]
    total_duration = row[:totalduration]
    notes = row[:notes]

    row_array << DateTime.strptime(timestamp, "%D %I:%M:%S %p").new_offset("+03:00").iso8601
    row_array << address.unicode_normalize
    row_array << zip.prepend("0") until zip.length == 5
    row_array << full_name.upcase
    foo_duration_seconds = convert_to_seconds(foo_duration)
    row_array << foo_duration_seconds
    bar_duration_seconds = convert_to_seconds(bar_duration)
    row_array << bar_duration_seconds
    row_array << foo_duration_seconds + bar_duration_seconds
    row_array << notes.encode('utf-8', invalid: :replace, undef: :replace) if notes != nil
    @parsed_array << row_array
  end
end

def write_new_csv(filename)
  CSV.open(filename, "w") do |csv|
    csv << ["Timestamp", "Address", "ZIP", "FullName", "FooDuration", "BarDuration", "TotalDuration", "Notes"]
    @parsed_array.each do |row|
      csv << row
    end
  end
end

def convert_to_seconds(time)
  time_array = time.split(":")
  time_array[0].to_f * 3600 + time_array[1].to_f * 60 + time_array[2].to_f
end

puts "What is the name of the file you want to convert?"
filename = gets.strip
read_csv(filename)

puts "What is the name you would like to give your parsed file?"
parsed_filename = gets.strip
write_new_csv(parsed_filename)
