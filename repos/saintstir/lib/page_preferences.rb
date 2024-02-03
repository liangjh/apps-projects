
##
#  This module contains all page preferences, which include things like favorites, page titles, and facebook "like" links
#  Or any other setting that can be set on a controller level.  We want to avoid bloating the base controller with a bunch of stuff
#

module PagePreferences
  
  # --- Page Preferences ---

  def show_favorite_link
    @favorite_link = true
  end

  def favorite_link_enabled?
    (@favorite_link == true)
  end

  def show_fb_like
    @fb_like = true
  end

  def fb_like_enabled?
    (@fb_like == true)
  end

  def set_page_title(title)
    @title = title
  end

  def page_title
    @title
  end



end
