#! /bin/bash



Name="Scorcese"

echo $Name

echo "$Name"


get_name() {
	echo $Name
}

echo "The Name is: $(get_name)"

: '

=========

f(){ 
	echo "123";
}

result="$(f)"

echo $result



=========

#Name=""
if [[ -z "$Name" ]]; then
	echo "Name is empty"
elif [[ -n "Name" ]]; then
	echo "Name is not empty"
fi



============================
echo “Is it morning? Please answer yes or no”
read timeofday

case "$timeofday" in
	yes | y | Yes | YES ) echo "Good Morning";;
	n* | N* ) echo "Good Afternoon";;
	* ) echo "Sorry, answer not recognized";;
esac
==================================

echo ${Name}
echo ${#Name}
echo ${Name/Sc/cS}
echo ${Name:0:2}

subName=${Name::4}
echo ${subName}

echo ${Name::-1}
echo ${Name:(-1)}
echo ${Name:(-2):1}
echo ${Name:3:-1}

vrt=`expr 5 / 5 `

echo $vrt

vrt=`expr 5 \* 5 `

echo $vrt



fileName="FightClub.cpp"

echo ${fileName%.cpp}
echo ${fileName%.cpp}.$subName


echo ${fileName##*.}

anotherFile="Inception.ok.cpp"
echo ${anotherFile#*.}

str="HELLO BUDDY"
echo ${str,}
echo ${str,,}


str="hello buddy"
echo ${str^}
echo ${str^^}

for i in *; do
	echo $i
	break
done

for i in {1..5}; do
	if [[ $i = 5 ]]; then
		echo $i
	else echo -n $i
	fi
done


=========================
echo "the number of args is $#"
a=1
for i in $*
do 
	echo "The $a no arg is $i"
	a=`expr $a + 1 `
done

==========================

==============================

password="abc"
echo "Enter password"
read pass
while [ $pass != $password ] 
do
	echo "Wrong Password,Try again"
	read pass
done

echo "Right Password"
===================================



================================
password="abc"
echo "Enter password"
read pass
until [ $pass = $password ] 
do
	echo "Wrong Password,Try again"
	read pass
done

echo "Right Password"
===================================




#========================================
function myfunc(){
	echo "Total arguments are: $#"
	echo "All  arguments are: $@"
	for i in $*; do
		echo -n "$i "
	done
	echo 
}


myfunc its not an easy game


#========================================
myfunc(){
	local myself='some value'
	echo $myself
}

result="$(myfunc)"

echo "$result"


#=========================================
isEven(){
	
	if [[ `expr $1 % 2` = 0 ]]; then
		echo "arg $1 is even"
	else echo "arg $1 is odd"
	fi
}

isEven 6
isEven 5


==============================






===============================



# To declare static Array 
# ${ARRAYNAME[WHICH_ELEMENT]:STARTING_INDEX}
# ${ARRAYNAME[WHICH_ELEMENT]:STARTING_INDEX:COUNT_ELEMENT}

arr=(All that glitters is not gold 2.3 2 4)
 
# To print all elements of array
#echo ${arr[@]}       
#echo ${arr[*]}
#echo ${arr[@]:0}    
#echo ${arr[*]:0} 

# To print elements from a particular index

#echo ${arr[@]:2}  #All the elements that position after 2nd position    
#echo ${arr[*]:3}  #All the elements that position after 3rd position

#echo ${arr[0]}
#echo $arr[1]


# To print first element
#echo ${arr[0]}        
#echo ${arr}

# To print particular element
#echo ${arr[3]}        
#echo ${arr[1]}  

#To print elements from a particular index

#echo ${arr[@]:0}     
#echo ${arr[@]:1}
#echo ${arr[@]:2}     
#echo ${arr[0]:1}   

# To print elements in range
#echo ${arr[@]:1:4}     
#echo ${arr[@]:2:3}     
#echo ${arr[0]:1:3} 

# Length of Particular element
#echo ${#arr[3]}        
#echo ${#arr}   


# Size of an Array
#echo ${#arr[@]}        
#echo ${#arr[*]}   


#if [[ ${arr[1]} = 'All' ]]; then
#		echo "Yes"
#	else echo "No"
#	fi




checkFor="gold"
count=0
#((count=count+20))
#echo $count

for t in ${arr[@]}; do
	if [[ $t = $checkFor ]]; then
		((count=count+1))
	fi
done
echo $count




function toCheckFor(){
	local data="$1"
	shift
	local newArr=("$@")
	local county=0
	for i in "${newArr[@]}";
		do
          if [[ $i = $data ]]; then
          	((county=county+1))
          fi
   	    done
	
	echo "Found $data for $county times"
}


toCheckFor "gold" "${arr[@]}"


'














