class Welcome

  def intro
    puts "Welcome To McDonald's Nutrition Finder"
    list_menu
  end

  def list_menu
    puts "Please select a category:"
    menu = Scraper.new.scrape_site_for_categories("https://www.mcdonalds.com/us/en-us.html")
    menu.each_with_index do |item, i|
      puts "#{i + 1}: #{item.flatten[0]}"
    end
    input = gets.strip until input.to_i > 0 && input.to_i <= menu.size
    puts "You Selected #{menu[input.to_i - 1].flatten[0]}"
    select_item(Scraper.new.scrape_category_for_list("https://www.mcdonalds.com#{menu[input.to_i - 1].flatten[1]}"), menu[input.to_i - 1].flatten[0])
  end

  def select_item(category, input)
    puts "Please select an item from #{input}"
    category.each_with_index {|item, i| puts "#{i + 1}: #{item.flatten[0]}"}
    input = gets.strip until input.to_i > 0 && input.to_i <= category.size
    puts "You selected #{category[input.to_i - 1].flatten[0]}"
    get_nutrition(Scraper.new.scrape_nutrition_info("https://www.mcdonalds.com#{category[input.to_i - 1].flatten[1]}"), category[input.to_i - 1].flatten[0])
  end

  def get_nutrition(nutrition_list, item_name)
    puts "\nHere is the nutrition information for #{item_name}:"
    nutrition_list.each do |item|
      puts "#{item.flatten[0]}: #{item.flatten[1]}"
    end
    continue?
  end

  def continue?
    puts "Would you like to continue to find more items? (y/n)"
    input = gets.strip.downcase
    input == "y" ? list_menu : bye
  end

  def bye
    puts "Thank You for using McDonald's Nutrition Finder"
  end
end
