require 'timeline_service'

##
# Initialize timeline service with all timelines that we intend to support
# Note:'require' of the class is needed, o/w it'll reload an uniniitalized timeline_service for each request

TimelineService.timelines = [
  Timeline::Feastday.new,
  Timeline::Century.new,
  Timeline::Europeriod.new
]

# We can control whether we turn caching on or off
TimelineService.cache_data = true



