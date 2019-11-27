if Rails.env.development?
  Marginalia::Comment.components = %i[
    application
    controller_with_namespace
    action
    line
    job
  ]
end

# See https://github.com/basecamp/marginalia#customization
