# Update an ease value
update_ease <- function(oldease, response) {
  
  # Response should be an integer in (1, 5)
  if (! response %in% 1:5) {
    stop("Response must be an integer between 1 and 5 inclusive")
  }

  # Calculate new ease according to sm2 algorithm
  # https://www.supermemo.com/english/ol/sm2.htm
  ease <- oldease - 0.8 + (0.28 * response) - (0.02 * (response ^ 2))

  # Ease should never fall below 1.3
  if (ease < 1.3) { ease <- 1.3 }

  # Ease should never rise above 3.5
  if (ease > 2.5) { ease <- 2.5 }

  ease
}

# Return a due date from a last answered date, ease and repetition index
due_when <- function(la_date, ease, repetition) {

  # Calculate the interval using the sm2 algorithm
  # https://www.supermemo.com/english/ol/sm2.htm
  calculate_interval <- function(repetition, ease) {
    if (repetition == 1) {
      interval <- 1
    } else if (repetition == 2) {
      interval <- 6
    } else {
      interval <- calculate_interval(repetition - 1, ease) * ease
    }
  }
  interval <- round(calculate_interval(repetition, ease))

  # Using lubridate, calculate the next due date
  if (! lubridate::is.Date(la_date)) { stop("la_date must be a Date object") }
  due_date <- la_date + lubridate::ddays(interval)

  due_date
}

# Update a note with a response and write to file
update_note <- function(note, response) {

  # Update the last answered date
  note$header$last_answered <- lubridate::today()

  # If the note doesn't have an ease or a repetition count initialise these
  # assuming this is the first time the note has been seen
  if (is.null(note$header$ease)) { 
    note$header$ease <- 2.5
  }
  if (is.null(note$header$repetitions)) { 
    note$header$repetitions <- 0
  }

  # Update the repetition count
  note$header$repetitions <- note$header$repetitions + 1

  # Update the ease
  note$header$ease <- update_ease(note$header$ease, response)

  # Write the updated note to file
  write_note(note)
}
