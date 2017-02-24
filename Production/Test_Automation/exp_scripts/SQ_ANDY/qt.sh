./run.sh 12                                                           >> result.log 2>&1

mail -s 'CAPSTONE TESTING' -S smtp=smtp3.hp.com daweiss1@gmail.com  < result.log
