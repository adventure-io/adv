if [[ ! -o interactive ]]; then
    return
fi

compctl -K _adv adv

_adv() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(adv commands)"
  else
    completions="$(adv completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
