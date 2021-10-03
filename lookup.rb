def get_command_line_argument
    # ARGV is an array that Ruby defines for us,
    # which contains all the arguments we passed to it
    # when invoking the script from the command line.
    # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <souce_place>"
      exit
    end
    ARGV.first
  end

  # `souce_place` contains the souce_place name we have to look up.
  souce_place = get_command_line_argument

  # File.readlines reads a file and returns an
  # array of string, where each element is a line
  # https://www.rubydoc.info/stdlib/core/IO:readlines
  dns_raw = File.readlines("zone")
  # ..
  # ..
  def parse_dns(dns_raw)
    dns_raw = dns_raw.map(&:strip).delete_if {|text| text.length == 0 }
    dns_raw=dns_raw[1..-1]
    data=Array.new(5){Array.new(3)}
    rows=[] 
    no_rows=4
    no_fields=2
       for row_index in 0..no_rows
           rows=dns_raw[row_index].strip.split(",")
            for col_index in 0..no_fields
               data[row_index][col_index]=rows[col_index].strip
            end
       end
    Hash[data.map {|key,val3,val4| [val3,{:type=>key,:target=>val4}]}]
  end

  def resolve(dns_destination,all_links, souce_place)
      record = dns_records[souce_place]
      if (!record)
        all_links=["Error: Record not found for #{souce_place}"]
        return all_links
      elsif record[:type] == "CNAME"
        all_links.push(record[:target])
        resolve(dns_destination,all_links,record[:target])
      elsif record[:type] == "A"
        all_links.push(record[:target])
        return all_links
      end
  end

  # ..
  # ..

  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.
  dns_records = parse_dns(dns_raw)
  all_links = [souce_place]
  all_links = resolve(dns_records, all_links, souce_place)
  puts all_links.join(" => ")
