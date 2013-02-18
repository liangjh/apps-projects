
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

    ##
    # Returns insignia (and description) for saint, given saint's attribs a
    # Once we generate a match, we return
    def get_insignia(saint)
      get_insignia_by_attribs(saint.attribs.map(&:code))
    end

    ##
    #  Return the appropriate insignia to render, given a list of attributes
    def get_insignia_by_attribs(attribs = [])
      res_insignia = @@default_insignia
      if (attribs.present?)
        attrib_set = make_set(attribs)
        @@insignia_list.each do |insig|
          if (attrib_set.include?(insig[0]))
            res_insignia = insig[1]
            break
          end
        end
      end
      res_insignia
    end

    ##
    #  Returns color for saint, given saint's attribs
    def get_color(saint)
      get_color_by_attribs(saint.attribs.map(&:code))
    end

    ##
    #  Return the appropriate color to render, given a list of attributes
    def get_color_by_attribs(attribs = [])
      res_color = @@default_color
      attrib_set = make_set(attribs)
      @@color_list.each do |clr|
        if (attrib_set.include?(clr[0]))
            res_color = clr[1]
            break
        end
      end
      res_color
    end

    private

    def make_set(elements = [])
      element_set = elements.inject(Set.new) do |accum_set, value|
        accum_set.add(value);
        accum_set
      end
      element_set
    end




  end




end
