clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local do_infogob 	"Dofiles\01. Infogob"
local do_ficha 		"Dofiles\02. Fichas"
local do_ubigeo 	"Dofiles\03. Ubigeos"
local do_luces 		"Dofiles\04. Nightlights"
local do_pnud 		"Dofiles\05. PNUD"
local do_enaho 		"Dofiles\06. Enaho"
local do_final 		"Dofiles\00. Final"

local input_infogob "Input\Infogob"
local input_ubigeo 	"Input\Ubigeos"
local input_ficha 	"Input\Fichas"
local input_luces 	"Input\Nightlights"
local input_pnud 	"Input\PNUD"
local input_enaho 	"Input\Enaho"

local middle_infogob "Middle\Infogob"
local middle_ubigeo "Middle\Ubigeos"
local middle_ficha 	"Middle\Fichas"
local middle_luces 	"Middle\Nightlights"
local middle_pnud 	"Middle\PNUD"
local middle_enaho 	"Middle\Enaho"
/*
* Crear nuevas carpetas
mkdir "`middle_infogob'"
mkdir "`middle_ubigeo'"
mkdir "`middle_ficha'"
mkdir "`middle_luces'"
mkdir "`middle_pnud'"
mkdir "`middle_enaho'"
*/
* Ubigeos
do "`do_ubigeo'\2010.do"
do "`do_ubigeo'\2014.do"
do "`do_ubigeo'\2014_v1.do"
do "`do_ubigeo'\2015.do"
do "`do_ubigeo'\2016.do"
do "`do_ubigeo'\2024.do"

* Infogob
do "`do_infogob'\1. import_excel.do"
do "`do_infogob'\2. autoridades_resumen.do"
do "`do_infogob'\3. candidatos_resumen.do"
do "`do_infogob'\4. resultados_resumen.do"
do "`do_infogob'\5. padron_resumen.do"
do "`do_infogob'\6. merge_infogob.do"
do "`do_infogob'\7. append_infogob.do"

* Municipios en los que postuló una mujer (de los 2 primeros candidatos) y hubo 
* resultados ajustados al 5%, 7% y 10%
do "`do_infogob'\8.1. MV5.do"
do "`do_infogob'\8.2. MV7.do"
do "`do_infogob'\8.3. MV10.do"

*Fichas
do "`do_ficha'\1. ficha_infogob_2006.do"
do "`do_ficha'\2. ficha_infogob_2010.do"
do "`do_ficha'\3. ficha_infogob_2014.do"
do "`do_ficha'\4. ficha_infogob_2018.do"
do "`do_ficha'\5. ficha_infogob_2022.do"
do "`do_ficha'\6. append_fichas.do"

*Nightlights
do "`do_luces'\1. Import_pbi.do"
do "`do_luces'\2. Mergepbi_ubigeo.do"

*PNUD
do "`do_pnud'\1. IDH-Perú.do"
do "`do_pnud'\2. Append_idh.do"

*Enaho
do "`do_enaho'\0. Pobreza monetaria.do"

*Estadísticas y resultados
do "`do_final'\1. Estadísticas Descriptivas_Informe.do"

/*
* Borrar la carpeta ahora vacía
rmdir "`middle_infogob'"
rmdir "`middle_ubigeo'"

* Eliminar todos los archivos dentro de la carpeta
erase "`middle_infogob'"
erase "`middle_ubigeo'"

* Si deseas imprimir un mensaje al final
display "Todos los dofiles se ejecutaron correctamente."
