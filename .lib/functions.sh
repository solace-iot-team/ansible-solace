

function assertFile() {
  if [[ $# -lt 2 ]]; then
      echo ">>> ERROR: usage: fileVar='\$(assertFile {log-script} {full-path/filename})'" 1>&2
      return 1
  fi
  local script=$1
  local file=$2
  if [[ ! -f "$file" ]]; then
    echo ">>> ERROR: script=$script, file='$file' does not exist" 1>&2
    return 1;
  fi
  echo $file
  return 0
}
