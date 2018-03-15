# Read a note file, returning an object containing the note header and content
read_note <- function(path) {

  # Get note content
  content <- rmarkdown:::read_lines_utf8(path, "utf8")

  # Parse out YAML front matter
  YAML <- rmarkdown:::parse_yaml_front_matter(content)

  # Parse out body of document
  body <- rmarkdown:::partition_yaml_front_matter(content)$body

  # Extract questions from body
  question_lines <- sapply(body, stringr::str_detect, "^\\*")
  questions <- body[question_lines]
  questions <- stringr::str_remove(questions, "^\\*\\s?")
  body <- body[!question_lines]

  # Return
  list(path = path, header = YAML, body = body, questions = questions)
}

# Write a note file
write_note <- function(note) {

  # Note should always specify its own path
  if (is.null(note$path) | ! fs::file_exists(note$path)) {
    stop("Invalid note path ", note$path)
  }

  header <- yaml::as.yaml(note$header)
  body <- paste(note$body, collapse = "\n")

  sink(note$path)
  cat("---\n")
  cat(header)
  cat("---\n")
  cat(body)
  sink()
}

# Return a list of notes
list_notes <- function(notes_directory) {
  note_files <- fs::dir_ls(notes_directory)
  purrr::map(note_files, read_note)
}
