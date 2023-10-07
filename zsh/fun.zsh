# Custom functions

# Make a directory and cd into it
mkcd() {
	mkdir "$1"
	cd "$1"
}

# Find which files in a project are the most garbage (complex)
garbage() {
	scc --by-file -s complexity
}

# Stops the process running on the specificed port
kill_port() {
    if [ -z "$1" ]; then
        echo "Please specify a port number."
        return 1
    fi

    local PORT=$1
    local PID=$(lsof -i :$PORT | grep LISTEN | awk '{print $2}' | uniq)

    if [ -z "$PID" ]; then
        echo "No process found running on port $PORT."
        return 1
    fi

    echo "Killing process $PID on port $PORT."
    kill -9 $PID
    if [ $? -eq 0 ]; then
        echo "Process on port $PORT killed successfully."
    else
        echo "Failed to kill process on port $PORT."
    fi
}

# Gum script for walking through a conventional commit
conventional_commit() {
    # check if we are inside a git repo
    git rev-parse --is-inside-work-tree > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "fatal: not a git repository (or any of the parent directories): .git."
      exit 1
    fi

    # check if we have any changes to commit
    git diff-index --quiet --cached HEAD
    if [ $? -eq 0 ]; then
      echo "fatal: no changes added to commit."
      exit 1
    fi

    TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
    SCOPE=$(gum input --placeholder "scope")

    # since the scope is optional, wrap it in parentheses if it has a value
    test -n "$SCOPE" && SCOPE="($SCOPE)"

    # pre-populate the input with the type(scope): so that the user may change it
    SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "summary of this change")
    DESCRIPTION=$(gum write --placeholder "details of this change (CTRL+D to finish)")

    # commit these changes
    echo "\ncommit preview:"
    echo "-----------------"
    echo "$SUMMARY"
    echo "$DESCRIPTION"
    echo "-----------------"
    gum confirm "commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
}

# show description of an http status code
httpstatus() {   
  if [ -z $1 ]; then   
    w3m -dump -no-graph https://httpstatuses.com 
  else   
    w3m -dump -no-graph https://httpstatuses.com/$1 | sed -n '/-----/q;p' | grep -v httpstatuses.com | grep --color -E "$1|"   
  fi  
}
