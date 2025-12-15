#!/bin/bash

is_integer() {
     if [[ $1 =~ ^-?[0-9]+$ ]]; then
        return 0 #return ok
    else
        return 1 #błąd - to nie int
    fi
}

echo -n "Enter number A: "
read int_A

echo -n "Enter number B: "
read int_B

if ! is_integer "$int_A"; then
    echo "ERROR: number A is not valid '$int_A'"
    exit 1
fi


if ! is_integer "$int_B"; then
    echo "ERROR: number B is not valid '$int_B'"
    exit 1
fi

# Obliczenia
sum=$(( num_A + num_B ))      # Suma
diff=$(( num_A - num_B ))     # Różnica
prod=$(( num_A * num_B ))     # Iloczyn
quot=$(( num_A / num_B ))     # Iloraz (dzielenie całkowite)

# Wynik – wysyłany na STDOUT (dobrze działa z foo=$(...))
echo "A: $num_A"
echo "B: $num_B"
echo "Sum: $sum"
echo "Difference: $diff"
echo "Product: $prod"
echo "Quotient: $quot"
