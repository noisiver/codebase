#!/bin/bash
function pull_drive
{
    cd $1
    drive pull -no-prompt
}

function push_drive
{
    cd $1
    drive push -no-prompt
    drive emptytrash -no-prompt
}
