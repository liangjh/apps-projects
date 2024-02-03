
##
#  Euro period is just another instance of centuries display, except we annotate the euro periods
#  The main thing is the eras override
#
module Timeline
  class Europeriod < Century

    def type
      "europeriod"
    end

    def name
      "European Periods"
    end

    def timeline_headline
      "Saints by European Eras"
    end

    def timeline_text
      "Timeline of all saints, by European historica periods"
    end

    def zoom_adjustment
      -2
    end

    def eras
      [
        {:headline => 'The Early Church', :startDate => '0', :endDate => '300'},
        {:headline => 'The Imperial Church', :startDate => '301', :endDate => '500'},
        {:headline => 'Early Middle Ages', :startDate => '501', :endDate => '1000'},
        {:headline => 'High Middle Ages', :startDate => '1001', :endDate => '1350'},
        {:headline => 'Renaissance', :startDate => '1351', :endDate => '1600'},
        {:headline => 'Baroque / Enlightment', :startDate => '1601', :endDate => '1800'},
        {:headline => 'Industrial Age', :startDate => '1800', :endDate => '1900'},
        {:headline => 'Post-Industrial / Contemporary', :startDate => '1901', :endDate => '2100'},
      ]
    end

  end
end
