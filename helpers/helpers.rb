module SomeHelpers

  def css_path(source)
    "/css/#{source}"
  end
  def js_path(source)
    "/js/#{source}"
  end
  def image_path(source)
    "/images/#{source}"
  end

  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def flash_types
    [:success, :notice, :warning, :error]
  end

  def protected!
    if session[:token]
      return true
    else
      redirect '/login'
      return false
    end
  end

  def passing_logged!
    if session[:token]
      redirect '/dashboard'
      return true
    end
  end

  def tag(name, content, options={})
    tag = "<#{name.to_s} "
    options.each do |key, value|
      if key == :selected
        tag << "#{key.to_s}" if value == true
      else
        tag << "#{key.to_s}=\"#{value}\""
      end
    end
    tag << (content.nil? ? '>' : ">#{content}</#{name.to_s}>")
    tag
  end

  def select(name, values, options={}, selected={})
    content = ""
    values.each do |val|
      content << tag(:option, val.first, :value => val.last, :selected => val.last == selected[:selected])
    end
    tag :select, content, options.merge(:id => name.to_s, :name => name.to_s)
  end

  def script_tag(file_name)
    %(<script src="/js/#{file_name}.js"></script>)
  end

  def stylesheet_tag(file_name)
    %(<link rel="stylesheet" href="/css/#{file_name}.css">)
  end
end
