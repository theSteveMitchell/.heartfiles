# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

#BASH ALIASES
alias newalias="edit ~/.zshrc" #opens this file (so...put this file there!)
alias refresh="source ~/. zshrc" #reload the profile to consume changes to this file"
alias hosts="edit /etc/hosts" #this file always opens read-only
alias sshconfig="edit ~/.ssh/config"

#DEVELOPMENT
alias code="open -a Visual\ Studio\ Code"

#RAILS/RUBY TASKS
alias brec="bundle exec rspec"
alias migrate="brake db:migrate && brake db:test:prepare"
