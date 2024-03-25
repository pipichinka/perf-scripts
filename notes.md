сборака PostreSQL с frame pointers ./configure CFLAGS="-fno-omit-frame-pointer".
сборка без ./configure CFLAGS="-fomit-frame-pointer".

влияние:
С fp есть вывод stack trace с опцией perf --call-graph=fp, иначе не показываются названия функций.
(объём перф записей с fp сильно меньше в отличии от dwarf).
вид fp:
![[Pasted image 20240306165822.png]]


radare2:

получение дебаг информации по elf фалу rabin2 -d ./path/to/file
в итоге получаем древовидную информацию о коде: типы переменных, их названия, названия функций...


radare -A ./path/to/file
мы попадаем в консоль для взаимодействия с файлом.
можно нажать "v" и мы попадём в окно с дисасемлированным файлом.


libc собрана с поддержкой fp.

