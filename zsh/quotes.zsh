QUOTES_FILE="$DOTFILE_PATH/quotes.json" 
PREVIOUS_AUTHOR_FILE="$DOTFILE_PATH/.previous_author"
PREVIOUS_SOURCE_FILE="$DOTFILE_PATH/.previous_source"

function sanitize_quote_input() {
  echo "$1" | sed 's/"/\\"/g' | sed "s/'/\\'/g" | sed 's/\n/\\n/g' | sed 's/\r//g' | sed 's/\t/\\t/g'
}

function quote() {

  # Check if the -p flag is set
  if [ "$1" = "-p" ]; then
    # Read the previous author and source from files if they exist
    [ -f "$PREVIOUS_AUTHOR_FILE" ] && AUTHOR=$(cat "$PREVIOUS_AUTHOR_FILE")
    [ -f "$PREVIOUS_SOURCE_FILE" ] && SOURCE=$(cat "$PREVIOUS_SOURCE_FILE")
  else
    AUTHOR=$(sanitize_quote_input "$(gum input --placeholder 'author')")
    SOURCE=$(sanitize_quote_input "$(gum input --placeholder 'source')")
  fi

  QUOTE=$(sanitize_quote_input "$(gum write --char-limit=0 --placeholder "quote")") 

  # Save the author and source for future use
  echo "$AUTHOR" > "$PREVIOUS_AUTHOR_FILE"
  echo "$SOURCE" > "$PREVIOUS_SOURCE_FILE"

  # Creating a JSON object
  JSON_STRING=$(printf '{"source": "%s", "author": "%s", "quote": "%s"}' \
    "$SOURCE" "$AUTHOR" "$QUOTE")

  # Ensuring that the file exists
  touch "$QUOTES_FILE"

  # Ensuring that the JSON file is an array if it's empty
  if [ ! -s "$QUOTES_FILE" ]; then
    echo '[]' > "$QUOTES_FILE" 
  fi

  # Adding JSON object to the JSON file
  gum format -- "$QUOTE" "" "**$AUTHOR**, *\"$SOURCE\"*"
  gum confirm "Save this quote?" && jq ". += [$JSON_STRING]" "$QUOTES_FILE" > tmp.json && \mv tmp.json "$QUOTES_FILE"
}

get_random_quote() {
  # Check if the file exists and is not empty
  if [ ! -s "$QUOTES_FILE" ]; then
    echo "No quotes available."
    return 1
  fi

  # Get a random quote from the JSON file
  # outputs each quote as a line, shuffles the lines, and outputs the first line
  RANDOM_QUOTE=$(jq -c '.[] | select(.quote != null)' "$QUOTES_FILE" | sort -R | head -n 1)

  # Check if jq or sort commands failed
  if [ $? -ne 0 ]; then
    echo "Error fetching quote."
    return 1
  fi
  
  # Extract fields from the JSON object
  AUTHOR=$(echo "$RANDOM_QUOTE" | jq -r '.author')
  QUOTE=$(echo "$RANDOM_QUOTE" | jq -r '.quote')
  SOURCE=$(echo "$RANDOM_QUOTE" | jq -r '.source')

  # check the length of source
  if [ ${#SOURCE} -gt 0 ]; then
    SOURCE=", *\"$SOURCE\"*"
  fi

  if [ $? -ne 0 ]; then
    echo "Error extracting quote information."
    return 1
  fi

  FORMATTED_QUOTE=$(gum format -- "$QUOTE" "" "**$AUTHOR**$SOURCE" "")

  gum style --width 80 --align left "$FORMATTED_QUOTE"

}
