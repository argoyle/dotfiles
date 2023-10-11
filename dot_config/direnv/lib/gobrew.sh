use_go() {
  local go_version=$1

  if [ "mod" == "${go_version}" ]; then
    gobrew use mod
  else
    gobrew use "${go_version}"
  fi
}
