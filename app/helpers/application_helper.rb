module ApplicationHelper
  def auto_links(str)
    str = link_hashtag(str)
    str.html_safe
  end

  def link_hashtag(str)
    str.gsub(/#(\w+)/, "<a href='/hashtag/\\1'>#\\1</a>")
  end
end