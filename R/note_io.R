# Read a note file, returning an object containing the note header and content
read_note <- function(file) {

  # Get note content
  content <- rmarkdown:::read_lines_utf8(file, "utf8")

  # Parse out YAML front matter
  YAML <- rmarkdown:::parse_yaml_front_matter(content)

  # Parse out body of document
  body <- rmarkdown:::partition_yaml_front_matter(content)$body
  body <- paste(body, collapse = "\n")

  # Return
  list(header = YAML, body = body)
}

# Write a note file
write_note <- function(note, file) {

  header <- yaml::as.yaml(note$header)
  body <- paste(note$body, collapse = "\n")

  sink(file)
  cat("---\n")
  cat(header)
  cat("---\n")
  cat(body)
  sink()
}
