#! /bin/bash

if [ $# == 0  ] ; then
        echo "ssh to remote..."
        ssh  -p 13778 zhangzs@cloudvm.china-vo.org
elif [ $1 == '-t' ] ;  then
        echo "copying $2 to remote server..."
        scp  -P 13778 $2 zhangzs@cloudvm.china-vo.org:/home/zhangzs/Documents
        ssh  -p 13778 zhangzs@cloudvm.china-vo.org
elif [ $1 == '-f' ] ; then
        echo "copying $2 from remote server..."
        scp -P 13778 zhangzs@cloudvm.china-vo.org:/home/zhangzs/Documents/$2 ./
fi

