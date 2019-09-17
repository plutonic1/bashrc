if [ "$TERM" != 'dumb'  ]
then
    echo "deprecated!!!"
    export TERM=xterm #tmux workaround
fi