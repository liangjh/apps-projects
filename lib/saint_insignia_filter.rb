
#//
#// Saint Insignia Filter
#//
#// Saints are given different insignia values and colors based upon
#// certain discrete attributes and metadata information
#// Given a saint, returns a label (if applicable) and a color
#//

class SaintInsigniaFilter


  class << self

    #//  Set list of insignias, by priority
    #//  Format: [[attrib_code, insignia, description]]  (array of arrays)
    def insignia_list=(list)
      @@insignia_list = list
    end

    #//  Set list of colors, by priority
    #//  Format: [[attrib_code, css_color]] (array of arrays)
    def color_list=(list)
      @@color_list = list
    end

    #//  System defaults
    def default_insignia=(dinsig); @@default_insignia = dinsig; end
    def default_color=(dcolor); @@default_color = dcolor; end

    #//  Returns insignia (and description) for saint, given saint's attribs a
    #//  Once we generate a match, we return
    def get_insignia(saint)
      res_insignia = @@default_insignia
      saint_attrib_map = saint.map_attribs_by_code #// all saint's attribs
      @@insignia_list.each do |insig|
        if (saint_attrib_map.has_key?(insig[0]))
          res_insignia = [insig[1], insig[2]]
          break
        end
      end
      res_insignia
    end

    #//  Returns color for saint, given saint's attribs
    def get_color(saint)
      res_color = @@default_color
      saint_attrib_map = saint.map_attribs_by_code  #// all saint's attribs
      @@color_list.each do |clr|
        if (saint_attrib_map.has_key?(clr[0]))
            res_color = clr[1]
            break
        end
      end
      res_color
    end

  end




end
