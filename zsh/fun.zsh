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

# show description of an http status code
httpstatus() {   
  if [ -z $1 ]; then   
    w3m -dump -no-graph https://httpstatuses.com 
  else   
    w3m -dump -no-graph https://httpstatuses.com/$1 | sed -n '/-----/q;p' | grep -v httpstatuses.com | grep --color -E "$1|"   
  fi  
}
