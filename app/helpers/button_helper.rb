module ButtonHelper 
  
  def submit_button
    if about_object
      if about_object.new_record?
        positive_button("Create")
      else
        positive_button("Save")
      end
    else
      positive_button("Save")
    end
  end
  
  def start_button
    if about_object.new_record?
      positive_button("Start")
    elsif about_object.active?
      stop_button
    else
      positive_button("Save")
    end
  end
  
  def stop_button(text="Stop", options={})
    negative_button(text,options)
  end
  
  def button(label,options = {})
    options[:name]||="submit"
    content_tag :button, label,{:type=>'submit'}.merge(options)
  end

  def positive_button(label,options={})
    options[:class]='positive '+options[:class].to_s     
    button(label,options)
  end

  def negative_button(label,options={})
    options[:class]='negative '+options[:class].to_s     
    button(label,options)
  end
  
  def button_link(label,options = {}, html_options = {}, *parameters_for_method_reference)
    html_options[:class]='button '+html_options[:class].to_s     
    link_to label,options, html_options, *parameters_for_method_reference
  end

  def cancel_link(label,options = {}, html_options = {}, *parameters_for_method_reference)
    html_options[:class]='cancel '+html_options[:class].to_s     
    link_to label,options, html_options, *parameters_for_method_reference
  end
    
  def positive_button_link(label,options = {}, html_options = {}, *parameters_for_method_reference)
    html_options[:class]='positive '+html_options[:class].to_s     
    button_link(label,options,html_options, *parameters_for_method_reference)
  end
  
end