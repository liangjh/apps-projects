
#//
#//  SAINTSTIR -- DIMENSIONS - INITIAL SEED
#//


#//  Metadata Keys
list_metadatakeys = MetadataKey.create([
    {:code => "name", :multi => false, :name => "Name", :description => "Name of saint", :meta_type => "SHORT"},
    {:code => "nickname", :multi => true, :name => "Nicknames", :description => "Saint known by any other names", :meta_type => "SHORT"},
    {:code => "suffix", :multi => false, :name => "Suffix", :description => "ie 'of [region]', 'the Great', etc", :meta_type => "SHORT"},
    {:code => "born", :multi => false, :name => "Born", :description => "Date of birth (or century / age, if N/A)", :meta_type => "SHORT"},
    {:code => "died", :multi => false, :name => "Died", :description => "Date of death (or century / age, if N/A)", :meta_type => "SHORT"},
    {:code => "feastday", :multi => false, :name => "Feast Day", :description => "Date of Saint's Recognized Feast", :meta_type => "SHORT"},
    {:code => "moderndaycountry", :multi => false, :name => "Modern-day Country", :description => "Modern-day country where this saint lived / ministered", :meta_type => "SHORT"},
    {:code => "specificgeoperiod", :multi => false, :name => "Specific GeoPeriod", :description => "Period / region specific to this saint's time and location", :meta_type => "SHORT"},
    {:code => "patronage", :multi => true, :name => "Patronage", :description => "What this saint is a recognized patron of", :meta_type => "SHORT"},
    {:code => "occupation", :multi => false, :name => "Occupation", :description => "Specific occupation of this saint", :meta_type => "SHORT"},
    {:code => "biography", :multi => true, :name => "Biography", :description => "Saint's biography (short)'", :meta_type => "LONG"},
    {:code => "trivia", :multi => true, :name => "Trivia", :description => "Interesting facts about this saint", :meta_type => "LONG"},
    {:code => "quotes", :multi => true, :name => "Quotes", :description => "Quotes by this saint", :meta_type => "LONG"},
    {:code => "novenasprayers", :multi => true, :name => "Novenas / Prayers", :description => "Specific novenas / prayers attributed to this saint", :meta_type => "LONG"},
    {:code => "moreinformation", :multi => true, :name => "More Information", :description => "", :meta_type => "LONG"},
    {:code => "bibliography", :multi => true, :name => "Bibliography", :description => "", :meta_type => "LONG"},
    {:code => "lifestories", :multi => true, :name => "Life Stories", :description => "", :meta_type => "LONG"}])


#//  All Attribute Categories
list_attribcats = AttribCategory.create([
    {:code => "century", :name => "Century", :multi => false, :description => "Century in which this saint lived", :visible => true},
    {:code => "feastmonth", :name => "Feast Month", :multi => false, :description => "Month of saint's feast day'", :visible => true},
    {:code => "gender", :name => "Gender", :multi => false, :description => "Male or Female", :visible => true},
    {:code => "saintstatus", :name => "Saint Status", :multi => true, :description => "What part on the path to recognized sainthood is this saint", :visible => true},
    {:code => "periodeurocentric", :name => "Period - EuroCentric", :multi => false, :description => "Historic Period in which this saint lived (in European / Church history)", :visible => true},
    {:code => "worldregion", :name => "World Region", :multi => false, :description => "Region of world where this saint lived", :visible => true},
    {:code => "vocation", :name => "Vocation", :multi => false, :description => "What kind of vocation this saint lived in life", :visible => true},
    {:code => "consecratedlife", :name => "Consecrated Life", :multi => true, :description => "The specific order of religious or consecrated life that this saint was a member of", :visible => true},
    {:code => "occupationsector", :name => "Occupation Sector", :multi => true, :description => "The general occupational sector this saint was a member of in life", :visible => true},
    {:code => "graces", :name => "Graces", :multi => true, :description => "Particular graces / virtues that this saint is particularly known for", :visible => true},
    {:code => "superpower", :name => "Superpower", :multi => true, :description => "Any supernatural powers that this saint may have have in life", :visible => true},
    {:code => "lifeexperience", :name => "Life Experience", :multi => true, :description => "Particular major experiences that this saint may have had in life", :visible => true}])


#//  Attribute: Century
spec_ac = list_attribcats.select { |x| x.name == "Century" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_1st", :name => " 1st", :description => " 1st Century", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_2nd", :name => " 2nd", :description => " 2nd Century", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_3rd", :name => " 3rd", :description => " 3rd Century", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_4th", :name => " 4th", :description => " 4th Century", :ord => 4, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_5th", :name => " 5th", :description => " 5th Century", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_6th", :name => " 6th", :description => " 6th Century", :ord => 6, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_7th", :name => " 7th", :description => " 7th Century", :ord => 7, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_8th", :name => " 8th", :description => " 8th Century", :ord => 8, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_9th", :name => " 9th", :description => " 9th Century", :ord => 9, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_10th", :name => "10th", :description => "10th Century", :ord => 10, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_11th", :name => "11th", :description => "11th Century", :ord => 11, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_12th", :name => "12th", :description => "12th Century", :ord => 12, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_13th", :name => "13th", :description => "13th Century", :ord => 13, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_14th", :name => "14th", :description => "14th Century", :ord => 14, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_15th", :name => "15th", :description => "15th Century", :ord => 15, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_16th", :name => "16th", :description => "16th Century", :ord => 16, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_17th", :name => "17th", :description => "17th Century", :ord => 17, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_18th", :name => "18th", :description => "18th Century", :ord => 18, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_19th", :name => "19th", :description => "19th Century", :ord => 19, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_20th", :name => "20th", :description => "20th Century", :ord => 20, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_21st", :name => "21st", :description => "21st Century", :ord => 21, :visible => true}])


#//  Attribute: Feast Month
spec_ac = list_attribcats.select { |x| x.name == "Feast Month" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_jan", :name => "Jan", :description => "January", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_feb", :name => "Feb", :description => "February", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_mar", :name => "Mar", :description => "March", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_apr", :name => "Apr", :description => "April", :ord => 4, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_may", :name => "May", :description => "May", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_jun", :name => "Jun", :description => "June", :ord => 6, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_jul", :name => "Jul", :description => "July", :ord => 7, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_aug", :name => "Aug", :description => "August", :ord => 8, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_sep", :name => "Sep", :description => "September", :ord => 9, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_oct", :name => "Oct", :description => "October", :ord => 10, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_nov", :name => "Nov", :description => "November", :ord => 11, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_dec", :name => "Dec", :description => "December", :ord => 12, :visible => true}])



#//  Attribute: Gender
spec_ac = list_attribcats.select { |x| x.name == "Gender" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_male", :name => "Male", :description => "Male", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_female", :name => "Female", :description => "Female", :ord => 2, :visible => true}])



#//  Attribute: Saint Status
spec_ac = list_attribcats.select { |x| x.name == "Saint Status" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_venerated", :name => "Venerated", :description => "Venerated - declared 'Servant of God' by Church, recognized as role model", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_beatified", :name => "Beatified", :description => "Beatified - given the title 'Blessed' by Church, must perform a posthumous miracle", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_canonized", :name => "Canonized", :description => "Canonized - given the title 'Saint' by Church, must perform a second posthumous miracle", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_doctor", :name => "Doctor of Church", :description => "A 'Doctor of Church' is recognized by the Church as having particular importance in the areas of theology or doctrine", :ord => 4, :visible => true}])



#//  Attribute: Period - EuroCentric
spec_ac = list_attribcats.select { |x| x.name == "Period - EuroCentric" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_earlychurch", :name => "The Early Church", :description => "0-300 AD (ca)", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_imperialchurch", :name => "The Imperial Church", :description => "300-500 AD (ca)", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_earlymiddle", :name => "Early Middle Ages", :description => "500-1000 AD (ca)", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_highmiddle", :name => "High Middle Ages", :description => "1000-1350 AD (ca)", :ord => 4, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_renaissance", :name => "Renaissance", :description => "1350-1600 AD (ca)", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_baroqueenlightenment", :name => "Baroque / Enlightenment", :description => "1600-1800 AD (ca)", :ord => 6, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_industrial", :name => "Industrial Age", :description => "1800-1900 AD (ca)", :ord => 7, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_modern", :name => "Modern Age", :description => "1900-present AD (ca)", :ord => 8, :visible => true}])



#//  Attribute: World Region
spec_ac = list_attribcats.select { |x| x.name == "World Region" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_weur", :name => "Western Europe", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_eeur", :name => "Eastern Europe", :description => "", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_mide", :name => "Middle East", :description => "", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_namer", :name => "Northern America", :description => "", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_csamer", :name => "Central / Southern America", :description => "", :ord => 4, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_nafri", :name => "Northern Africa", :description => "", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_csafri", :name => "Central / Southern Africa", :description => "", :ord => 6, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_easipac", :name => "Eastern Asia / Pacific", :description => "", :ord => 7, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_sasi", :name => "Southern Asia", :description => "", :ord => 8, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}.casi", :name => "Central Asia", :description => "", :ord => 8, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_aus", :name => "Australia", :description => "", :ord => 9, :visible => true}])



#//  Attribute: Vocation
spec_ac = list_attribcats.select { |x| x.name == "Vocation" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_laysingle", :name => "Lay - Single", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_laymarried", :name => "Lay - Married", :description => "", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_nun", :name => "Nun", :description => "", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_monk", :name => "Monk", :description => "", :ord => 4, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_deacon", :name => "Deacon", :description => "", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_priest", :name => "Priest", :description => "", :ord => 6, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_bishop", :name => "Bishop", :description => "", :ord => 7, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_cardinal", :name => "Cardinal", :description => "", :ord => 8, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_pope", :name => "Pope", :description => "", :ord => 9, :visible => true}])



#//  Attribute: Consecrated Life
#//  This list is very incomplete.  This dimension definitely needs more work
spec_ac = list_attribcats.select { |x| x.name == "Consecrated Life" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_franciscan", :name => "Franciscan", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_dominican", :name => "Dominican", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_carmelite", :name => "Carmelite", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_mercedarian", :name => "Mercedarian", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_augustinian", :name => "Augustinian", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_cistercian", :name => "Cistercian", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_trappist", :name => "Trappist", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_jesuit", :name => "Jesuit", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_benedictine", :name => "Benedictine", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_opusdei", :name => "Opus Dei", :description => "", :ord => 1, :visible => true}])



#//  Attribute: Occupation Sector
spec_ac = list_attribcats.select { |x| x.name == "Occupation Sector" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_agri", :name => "Agriculture", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_arts", :name => "Arts", :description => "", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_comm", :name => "Commerce", :description => "", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_eng", :name => "Engineering", :description => "", :ord => 4, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_gov", :name => "Government", :description => "", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_hcmed", :name => "Health Care / Medicine", :description => "", :ord => 6, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_math", :name => "Mathematics", :description => "", :ord => 7, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_philtheo", :name => "Philosophy / Theology", :description => "", :ord => 8, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_reli", :name => "Religious", :description => "", :ord => 9, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_teach", :name => "Teaching", :description => "", :ord => 10, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_home", :name => "Homemaker", :description => "", :ord => 11, :visible => true}])



#//  Attribute: Graces
spec_ac = list_attribcats.select { |x| x.name == "Graces" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_charity", :name => "Charity", :description => "", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_compassion", :name => "Compassion", :description => "", :ord => 10, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_confidence", :name => "Confidence", :description => "", :ord => 15, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_courage", :name => "Courage", :description => "", :ord => 20, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_diligence", :name => "Diligence", :description => "", :ord => 25, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_perspective", :name => "Eternal Perspective", :description => "", :ord => 30, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_forgiveness", :name => "Forgiveness", :description => "", :ord => 35, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_fortitude", :name => "Fortitude", :description => "", :ord => 40, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_generosity", :name => "Generosity", :description => "", :ord => 45, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_grace", :name => "Grace", :description => "", :ord => 50, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_holiness", :name => "Holiness", :description => "", :ord => 55, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_hope", :name => "Hope", :description => "", :ord => 60, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_humility", :name => "Humility", :description => "", :ord => 65, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_joy", :name => "Joy", :description => "", :ord => 70, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_justice", :name => "Justice", :description => "", :ord => 75, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_kindness", :name => "Kindness", :description => "", :ord => 80, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_love", :name => "Love", :description => "", :ord => 85, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_meekness", :name => "Meekness", :description => "", :ord => 90, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_mercy", :name => "Mercy", :description => "", :ord => 95, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_mortification", :name => "Mortification", :description => "", :ord => 100, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_obedience", :name => "Obedience", :description => "", :ord => 105, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_perfection", :name => "Perfection", :description => "", :ord => 110, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_prayer", :name => "Prayer", :description => "", :ord => 115, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_purpose", :name => "Purpose", :description => "", :ord => 120, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_simplicity", :name => "Simplicity", :description => "", :ord => 125, :visible => true}])



#//  Attribute: Superpower
spec_ac = list_attribcats.select { |x| x.name == "Superpower" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_bilocation", :name => "Bilocation", :description => "", :ord => 0, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_levitation", :name => "Levitation", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_inedia", :name => "Inedia", :description => "", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_visionary", :name => "Visionary", :description => "", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_stigmata", :name => "Stigmata", :description => "", :ord => 4, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_incoruptible", :name => "Incorruptible", :description => "", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_liquefaction", :name => "Liquefaction", :description => "", :ord => 6, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_odorofsanctity", :name => "Odor of Sanctity", :description => "", :ord => 7, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_healingtouch", :name => "Healing Touch", :description => "", :ord => 8, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_clairvoyance", :name => "Clairvoyance", :description => "", :ord => 9, :visible => true}])



#//  Attribute: Life Experiences
spec_ac = list_attribcats.select { |x| x.name == "Life Experience" }
Attrib.create([
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_conversion", :name => "Conversion", :description => "", :ord => 1, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_darknight", :name => "Dark Night", :description => "", :ord => 2, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_disability", :name => "Disability", :description => "", :ord => 3, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_martyrdom", :name => "Martyrdom", :description => "", :ord => 4, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_addiction", :name => "Addiction", :description => "", :ord => 5, :visible => true},
    {:attrib_category_id => spec_ac[0].id, :code => "#{spec_ac[0].code}_temptation", :name => "Temptation", :description => "", :ord => 6, :visible => true}])










