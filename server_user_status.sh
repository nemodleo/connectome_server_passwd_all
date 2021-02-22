#!/bin/bash

# File Loading
rm ~/server_management/passwd/passwd_file/passwd_*
cp /etc/passwd ~/server_management/passwd/passwd_file/passwd_gateway_$(date "+%Y:%m:%d|%H:%M:%S")
nodes="master node1 node2 storage"
for node in $nodes; do
  scp $node:/etc/passwd ~/server_management/passwd/passwd_file/passwd_${node}_$(date "+%Y:%m:%d|%H:%M:%S")
done


# PreProcessing
echo -n > ~/server_management/passwd/summary_passwd_tmp
for passwd in $(ls ~/server_management/passwd/passwd_file); do	
	node=$(echo $passwd | cut -f 2 -d"_")
	awk -v node=$node '{ split($0, arr, ":"); if( arr[3]>=10000 && arr[3]<20000 || arr[4]==10000 ) printf("%s\t%s\n",node,$0) }' ~/server_management/passwd/passwd_file/$passwd >> ~/server_management/passwd/summary_passwd_tmp
done

sort ~/server_management/passwd/summary_passwd_tmp > ~/server_management/passwd/summary_passwd_sorted_tmp
sort -k 2 ~/server_management/passwd/summary_passwd_sorted_tmp > ~/server_management/passwd/summary_passwd_sorted
rm ~/server_management/passwd/summary_passwd_tmp ~/server_management/passwd/summary_passwd_sorted_tmp
#cat ~/server_management/passwd/summary_passwd_sorted


# To Matrix
declare -A matrix
num_rows=$(awk '{print $1}' ~/server_management/passwd/summary_passwd_sorted | sort | uniq | wc -l)
num_columns=6

for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
        matrix[$i,$j]='X'
    done
done

declare -A matrix_node
nodes=(gateway master node1 node2 storage)
k=1
for node in ${nodes[@]} 
do
	matrix_node[$node]=$k
	k=$(expr $k + 1)
done

tmp_account="a"
tmp_index=1
while read line
do
    node=$(echo $line | cut -f 1 -d" ")
    account=$(echo $line | cut -f 2 -d" ")
    
    if [ ${tmp_account} = "a" ] 
    then
    	:
    elif [ ${tmp_account} != ${account} ] 
    then
    	matrix[$tmp_index,6]=$tmp_account
    	tmp_index=$(expr $tmp_index + 1)
    fi
    matrix[$tmp_index,${matrix_node[$node]}]='O'
    tmp_account=$account
done < ~/server_management/passwd/summary_passwd_sorted
matrix[$tmp_index,6]=$tmp_account


# Matrix print
f1="%5s\t"
f2="%-12s"

printf "$f1" '#'
for node in ${nodes[@]} 
do # ha............
    printf "$f2" $node
done
printf "$f2" "Account"
echo

for ((i=1;i<=num_rows;i++)) do
    printf "$f1" $i
    for ((j=1;j<num_columns;j++)) do
        printf "$f2" ${matrix[$i,$j]}
    done
    printf "%s" ${matrix[$i,$num_columns]}
    echo
done

rm ~/server_management/passwd/summary_*
