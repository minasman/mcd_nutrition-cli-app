require 'nokogiri'
require 'open-uri'
require 'pry'
require 'watir'
require 'webdrivers'

class Scraper
  def scrape_site_for_categories(url)
    categories = []
    site = Nokogiri::HTML(open(url))
    site = site.css(".vertical-middle")
    site.each do |category|
      categories << {category.text.strip => category.css("a").attribute("href").value}
    end
    categories
  end

  def scrape_category_for_list(categrory)
    item_list = []
    site = Nokogiri::HTML(open(categrory))
    site = site.css(".zoom-anim-parent")
    site.each do |item|
      item_list << {item.css("div div div h4").text => item.css("a").attribute("href").value}
    end
    item_list
  end

  def scrape_evm_list(category)
    item_list = []
    site = Nokogiri::HTML(open(category))
    site = site.css(".zoom-anim-parent")
    site.each do |item|
      item_list << item.css("div div div div h3").text
    end
    item_list
  end

  def scrape_evm_nutrition_info(item_picked, meal_site)
    nutrition_site = []
    mock = Watir::Browser.new :chrome, headless: true
    mock_site = mock.goto meal_site
  
    binding.pry
    site = Nokogiri::HTML.parse(mock.html)
    site = site.css(".zoom-anim-parent")
    site.each do |item|
        puts "Item = #{item_picked} and I am at #{item.css("div div div div h3").text}"
      if item.css("div div div div h3").text == item_picked
        puts "found #{item_picked}"
        puts item.css("div div div div p a").attribute("href").value
        mock_site.links(:text =>'Learn more about Egg McMuffin').click
        binding.pry
      end
    end
  end

  def scrape_nutrition_info(item)
    i = 0
    nutrition_list = []
    mock = Watir::Browser.new :chrome, headless: true
    mock_site = mock.goto item
    site = Nokogiri::HTML.parse(mock.html)
    site = site.css(".nutrition-numbers")
    while i < 4 do
      nutrition_list << {site.css("div div ul li")[i].css("div.type span")[0].text => site.css("div div ul li")[i].css("div.number span")[0].text}
      i += 1
    end
    i = 0
    while i < 11 do
      nutrition_list << {site.css("div.detailed div ul li")[i].css("span")[0].text => site.css("div.detailed div ul li")[i].css("span")[1].text}
      i += 1
    end
    nutrition_list
  end

  def test
    #mock = Watir::Browser.new
    mock_site = Watir::Browser.start 'https://www.mcdonalds.com/us/en-us/product/quarter-pounder-with-cheese.html'
    site = Nokogiri::HTML.parse(mock_site.html)
    binding.pry
    #site.css("div.numbers span")[0].text  -- this should give me calories

  end
end
