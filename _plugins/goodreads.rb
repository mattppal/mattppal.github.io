require 'rss'
require 'open-uri'
require 'yaml'
require 'nokogiri'

module Readings
# Runs during jekyll build
    class Generator < Jekyll::Generator
        safe true
        priority :high

        def generate(site)
            reading_url = 'https://www.goodreads.com/review/list_rss/89626431?key=Ejk2W2RVCXJvlfGrIcEpK6Yk4o_3eHZsxByi9i7GODkPQy4v&shelf=currently-reading';
            read_url = 'https://www.goodreads.com/review/list_rss/89626431?key=Ejk2W2RVCXJvlfGrIcEpK6Yk4o_3eHZsxByi9i7GODkPQy4v&shelf=read'
            
            reading_path = site.in_source_dir('_data/reading.yml')
            read_path = site.in_source_dir('_data/read.yml')
            
            reading_books = []
            URI.open(reading_url) do |rss|
                feed = RSS::Parser.parse(rss)
                # Add fake virtual documents to the collectionex
                feed.items.each do |item|
                    puts "Reading: #{item.title}"
                    
                    parsed = Nokogiri::HTML.parse(item.description)

                    author = item.description.match(/author:\s*((\w|\s|\.|\/)*)/)[1]
                    date_read = item.description.match(/read\s*at:\s*((\d|\/)*)/)[1]
                    img_src = parsed.xpath("//img").attr('src').text
                    url = parsed.xpath("//a").attr('href').text
                    guid = item.link.split('/')[-1].split('?')[0]
                    

                    payload = {'title' => item.title, 
                                'link' => url,
                                'img_src' => img_src,
                                'date_read' => item.pubDate.to_date,
                                'author' => author,
                                # 'description' => item.description,
                                'guid' => guid

                    }

                    reading_books.append(payload)
                   
                end
            end
            
            File.open(reading_path, "w") do |f| 
                f.write(reading_books.to_yaml) 
            end

            current_books = []
            reading_books.each do |r|
                current_books.append(r['guid'])
            end

            # data = YAML::load_file(path)
            read_books = []
            URI.open(read_url) do |rss|
                feed = RSS::Parser.parse(rss)
                # Add fake virtual documents to the collection
                feed.items.each do |item|
                    
                    puts "Read: #{item.title}"
                    
                    parsed = Nokogiri::HTML.parse(item.description)

                    author = item.description.match(/author:\s*((\w|\s|\.|\/)*)/)[1]
                    date_read = item.description.match(/read\s*at:\s*((\d|\/)*)/)[1]
                    url = parsed.xpath("//a").attr('href').text
                    img_src = parsed.xpath("//img").attr('src').text
                    guid = item.link.split('/')[-1].split('?')[0]

                    payload = {'title' => item.title, 
                                'link' => url,
                                'img_src' => img_src,
                                'date_read' => item.pubDate.to_date,
                                'author' => author,
                                # 'description' => item.description,
                                'guid' => guid

                    }
                    if current_books.include?(guid)
                        puts guid
                    else
                        read_books.append(payload)
                    end
                    
                
                end
            end
            # read_books =  read_books.slice(0,10)
            
            File.open(read_path, "w") do |f| 
                f.write(read_books.to_yaml) 
            end
        end
    end
end
