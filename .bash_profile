[ -r ~/.bashrc ] && source ~/.bashrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zo/google-cloud-sdk/path.bash.inc' ]; then . '/Users/zo/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/zo/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/zo/google-cloud-sdk/completion.bash.inc'; fi
