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
            # TODO: Insert code here to fetch RSS feeds
            url = 'https://www.goodreads.com/review/list_rss/89626431?key=Ejk2W2RVCXJvlfGrIcEpK6Yk4o_3eHZsxByi9i7GODkPQy4v&shelf=currently-reading';
            
            path = site.in_source_dir('_data/reading.yml')

            File.delete(path) if File.exist?(path)
            File.new(path, "w")

            data = YAML::load_file(path)
            books = []
            URI.open(url) do |rss|
                feed = RSS::Parser.parse(rss)
                # Add fake virtual documents to the collection
                feed.items.each do |item|
                    # puts "Item: #{item.title}"
                    
                    parsed = Nokogiri::HTML.parse(item.description)

                    author = item.description.match(/author:\s*((\w|\s|\.|\/)*)/)[1]
                    date_read = item.description.match(/read\s*at:\s*((\d|\/)*)/)[1]
                    img_src = parsed.xpath("//img").attr('src').text
                    

                    payload = {'title' => item.title, 
                                'link' => item.link,
                                'img_src' => img_src,
                                'date_read' => item.pubDate.to_date,
                                'author' => author,
                                # 'description' => item.description,
                                'guid' => item.link.split('/')[-1].split('?')[0]

                    }

                    books.append(payload)
                   
                end
            end
            File.write(path, books.to_yaml)
        end
    end
end