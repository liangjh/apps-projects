
#
# Record of all edits made on a given saint
#
# Columns:
#   id, saint_id, edited_by, comment
#   created_at, updated_at
#
class SaintEditAudit < ActiveRecord::Base

  belongs_to :saint




end

