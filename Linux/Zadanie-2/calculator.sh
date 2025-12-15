#!/bin/bash

# Sprawdzenie czy podano dokładnie dwa argumenty
if [ $# -ne 2 ]; then
    echo "Usage: $0 <number1> <number2>"   # Informacja jak używać
    exit 1  #1 oznacz błąd bądz rzuczniem błędu
fi


int_A=${1}
int_B=${2}

# Obliczenia
sum=$(( int_A + int_B ))
diff=$(( int_A - int_B ))
prod=$(( int_A * int_B ))
quot=$(( int_A / int_B ))

echo "liczba A: $int_A"
echo "libczba B: $int_B"
echo "Sum: $sum"
echo "Difference: $diff"
echo "Product: $prod"
echo "Quotient: $quot"


# Normalne wywołanie
# ./calculator.sh 10 3


# Przypisanie do zmiennej foo2
# foo2=$(./calculator.sh 10 3)