#!/bin/bash


is_number(){
    if [[ $1 =~ ^-?[0-9]*\.?[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

echo -n "Enter number A: "
read int_A

echo -n "Enter number B: "
read int_B

if ! is_number "$int_A"; then
    echo "ERROR: number A is not valid '$int_A'"
    exit 1
fi


if ! is_number "$int_B"; then
    echo "ERROR: number B is not valid '$int_B'"
    exit 1
fi


sum=$(bc <<< "$int_A + $int_B")
diff=$(bc <<< "$int_A - $int_B")
prod=$(bc <<< "$int_A * $int_B")
quot=$(bc <<< "$int_A / $int_B")

# Wyświetlenie wyników
echo "A: $int_A"
echo "B: $int_B"
echo "Sum: $sum"
echo "Difference: $diff"
echo "Product: $prod"
echo "Quotient: $quot"