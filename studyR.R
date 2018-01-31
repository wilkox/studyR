# Note file
file <- "note.md"

# Get YAML
input_lines <- rmarkdown:::read_lines_utf8(file, "utf8")
yaml_front_matter <- rmarkdown:::parse_yaml_front_matter(input_lines)
