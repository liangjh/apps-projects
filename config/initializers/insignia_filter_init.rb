require 'saint_insignia_filter'

#//  Sets the saintstir insignia and color scheme on the isotope explore page
#//  Each saint is given a color (and insignia, if applicable), based upon
#//  a priorized list of attribs, if they apply for a given saint


#//  List of *prioritized* insignias, by attribute code
SaintInsigniaFilter.insignia_list = [
  ["saintstatus_doctor", "DCTR", "Doctor of Church"],
  ["lifeexperience_martyrdom", "MTYR", "Martyr"],
  ["vocation_pope", "POPE", "Pope"],
  ["vocation_bishop", "BSHP", "Bishop"],
  ["vocation_cardinal","CRDL", "Cardinal"],
  ["occupationsector_reli", "RLGS", "Religious (Monk, Nun, Priest)"],
]


#//  List of *prioritized* colors, by attribute code
SaintInsigniaFilter.color_list = [
  ["saintstatus_doctor", "cstm1-elem"],
  ["lifeexperiences_martyrdom", "cstm4-elem"],
  ["vocation_pope", "cstm2-elem"],
  ["vocation_bishop", "cstm2-elem"],
  ["vocation_cardinal","cstm2-elem"],
  ["occupationsector_reli", "cstm3-elem"],
]


#//  System defaults (in case specific case not found)
SaintInsigniaFilter.default_insignia = ["",""]
SaintInsigniaFilter.default_color = "basic-elem"

Rails.logger.info("Initialized saint insignia filters")

