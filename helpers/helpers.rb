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

  def login_required
    if session[:token]
      return true
    else
      halt 401, slim(:'401')
      return false
    end
  end

  def passing_logged
    if session[:token]
      redirect '/projects'
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
    path_prefix = development? ? '/assets/' : '/js/'
    suffix = development? ? '' : ".min"
    %(<script src="#{path_prefix}#{file_name}#{suffix}.js"></script>)
  end
   
  def stylesheet_tag(file_name)
    path_prefix = development? ? '/assets/' : '/css/'
    suffix = development? ? '' : ".min"
    %(<link rel="stylesheet" href="#{path_prefix}#{file_name}#{suffix}.css">)
  end
end
