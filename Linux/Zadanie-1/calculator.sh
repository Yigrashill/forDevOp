!/bin/bash

# Hardkodowane liczby
int_A=10
int_B=3

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

# Odpalenie visual studio code (jeśli się nie zakomentuje będzie jak w pętli wykonywać samą siebię)
# ./calculator.sh

# Normalne odpalenie w konsoli
# code calculator.sh


# dopisanie wyniku całego skryptu do foo i odpalenie w consoli
# foo=$(./calculator2.sh)
# echo "$foo"
