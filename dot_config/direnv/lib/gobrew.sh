use_go() {
  local go_version=$1
  out=$(gobrew install "${go_version}")
  version=$(echo "${out}" | grep "Downloading version:" | rev | cut -d\  -f 1 | rev)
  export PATH=~/.gobrew/versions/${version}/go/bin:${PATH}
  export GOROOT=~/.gobrew/versions/${version}/go
}
