require "rexml/document"

# Default is 10MB
REXML::Security.entity_expansion_text_limit = 100_000_000

# Default is 10K
REXML::Security.entity_expansion_limit = 100_000
