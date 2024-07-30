# frozen_string_literal: true

# Ensure ActiveStorage serves the correct MIME types for images
Rails.application.config.active_storage.content_types_to_serve_as_binary -= ['image/png', 'image/jpg', 'image/jpeg']
Rails.application.config.active_storage.content_types_allowed_inline += ['image/png', 'image/jpg', 'image/jpeg']
