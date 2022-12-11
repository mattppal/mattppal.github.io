require 'rss'
require 'open-uri'
require 'yaml'
require 'nokogiri'

Jekyll::Hooks.register :site, :pre_render do |site, payload|
    blogs_url = 'https://www.zuar.com/blog/author/matt-palmer/rss/'
    
    def get_rss_items(input_url)
        item_list = []
        URI.open(input_url) do |rss|
            doc = Nokogiri::XML(rss)
            puts doc
            # Add fake virtual documents to the collectionex
            feed.items.each do |item|
                parsed = Nokogiri::XML.parse(item.description)

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
                # puts item.title
                item_list.append(payload)
            end
        end
        return item_list
    end

    site.data['reading'] = get_rss_items(reading_url)
    site.data['read'] = get_rss_items(read_url)

end