class Welcome

  def intro
    puts "Welcome To The Fast Food Nutrition Finder"
    list_restaurants
  end

  def list_restaurants
    puts "\nPlease select a Restaurant by number:"
    restaurants = Scraper.new.scrape_site_for_restaurants("https://fastfoodnutrition.org/")
    restaurants.each_with_index {|restaurant, i| puts "#{i + 1}: #{restaurant.flatten[0]}"}
    selection = gets.strip.to_i
    puts "\nYou selected #{restaurants[selection - 1].flatten[0]}"
    select_category(Scraper.new.scrape_restaurant_categories(restaurants[selection - 1]),"https://fastfoodnutrition.org#{restaurants[selection - 1].flatten[1]}")
  end

  def select_category(categories, item_site)
    puts "\nPlease select a Category of Menu Items:"
    categories.each_with_index {|category, i| puts "#{i + 1}: #{category}"}
    selection = gets.strip.to_i
    puts "\nYou selected #{categories[selection - 1]}"
    select_item(Scraper.new.scrape_category_items(categories[selection - 1], selection, item_site))
  end

  def select_item(menu_item_list)
    i = 1
    puts "Please select an item:"
    menu_item_list.each do |item|
      puts "#{i}: #{item.flatten[0]}"
      i += 1
    end
    selection = gets.strip.to_i
    puts "You selected #{menu_item_list[selection - 1].flatten[0]}"
    binding.pry
    get_nutrition(Scraper.new.scrape_nutrition_info(menu_item_list[selection - 1]))
  end

  def get_nutrition(nutrition_list, item_name)
    puts "\nHere is the nutrition information for #{item_name}:"
    
    nutrition_list.each do |item|
      puts "#{item.flatten[0]}: #{item.flatten[1]}"
    end
    continue?
  end

  def get_evm_nutrition(a)
    puts "IN get_evm_nutrition"
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
