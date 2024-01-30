use_go() {
  local go_version=$1
  out=$(gobrew install "${go_version}")
  version=$(echo "${out}" | grep "Downloading version:" | rev | cut -d\  -f 1 | rev)
  if [[ -z $version ]]; then
    version=$(echo "${out}" | grep "Version: " | cut -d\  -f 4)
  fi
  export PATH=~/.gobrew/versions/${version}/go/bin:${PATH}
}
