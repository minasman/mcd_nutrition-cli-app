require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def scrape_site_for_restaurants(url)
    restaurants = []
    site = Nokogiri::HTML(open(url))
    site = site.css(".restaurant_list li")
    site.each do |restaurant|
      restaurants << {restaurant.css("a").text.strip => restaurant.css("a").attribute("href").value}
    end
    restaurants
  end

  def scrape_restaurant_categories(category) #passed hash
    category_list = []
    url = "https://fastfoodnutrition.org#{category.flatten[1]}"
    site = Nokogiri::HTML(open(url))
    site = site.css("#contentarea a.toggle_category.toggle_div")
    site.each do |item|
      category_list << item.css("h2").text unless item.css("h2").text == "Most Popular Items"
    end
    category_list
  end

  def scrape_category_items(item_name, index, item_site)
      item_list = []
      site = Nokogiri::HTML(open(item_site))
      site = site.css("#contentarea div.categories")[index].css("ul div li")
      site.each do |item|
        item_list << {item.css("a").text => item.css("a").attribute("href").value}
      end
      item_list
  end

  def scrape_nutrition_info(item) #get a hash
    index = 2
    nutrition_list = []
    url = "https://fastfoodnutrition.org#{item.flatten[1]}"
    site = Nokogiri::HTML(open(url))
    site = site.css(".item_nutrition tbody tr")
    binding.pry
    nutrition_list << {site.css("tr")[2].css("td a span").text => site.css("tr")[2].css("td td").text}
  end

end
