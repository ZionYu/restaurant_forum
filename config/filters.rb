module Filters
  def define_filters
    Filters.instance_methods.each do |symbol_method_name|
      send(symbol_method_name.to_s) unless symbol_method_name == :define_filters
    end
  end

  def over_one_thousand
    filter :over_one_thousand, &lambda {gte(:searchSessions, 1000)}
  end

  def over_two_thousands
    filter :over_one_thousand, &lambda {gte(:searchSessions, 2000)}
  end

  def search_keyword_is_monster_hunter
    filter :search_keyword_is_monster_hunter, &lambda {eql(:searchKeyword, 'モンスターハンター')}
  end

  def recruit_html_page
    filter :recruit_html_page, &lambda {contains(:pagePath, 'recruit.html')}
  end

  def recruit_entry_html_page
    filter :recruit_entry_html_page, &lambda {contains(:pagePath, 'recruit_entry.html')}
  end

  def real_store_page
    filter :real_store_page, &lambda {contains(:pagePath, 'store.html')}
  end

  def chrome_or_fx
    filter :chrome_or_fx, &lambda {['Chrome', 'Firefox'].map {|browser| matches(:browser, browser)}}
  end


  # AND-Filter: using method-chain
  # OR-Filter: ref below
  # filter(:browsers) {|*browsers| browsers.map {|browser| matches(:browser, browser)}}
  # browsers("Firefox", "Safari", profile)
end