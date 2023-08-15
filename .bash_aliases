alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias cpplint='clang-tidy -checks=clang-analyzer-cplusplus*,google-*,readability-*,misc-*,bugprone-*,performance-*,modernize-* \
    -config="{CheckOptions: [ {key: readability-identifier-naming.VariableCase, value: CamelCase} ]}" main.cpp '

alias conda='micromamba'

