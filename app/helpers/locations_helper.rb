module LocationsHelper
  
  def checkbox_helper(value)
    if value == true
      image_tag('check.png')
    else
      image_tag('cancel.png')
    end
  end
  
  def class_tags(location)
    tags = []
    location.categories.each do |category|
      if category.present?
        tags << 'category_' + category.id.to_s
      end
    end
    location.languages.each do |language|
      if language.present?
        tags << 'language_' + language.id.to_s + ' '
      end
    end
    return tags.join(' ')
  end
end
