# DS 1
Moje poznámky k předmětu Databázové systémy I.

# Projekt

## Vize

### PROČ?

Vedení firmy se rozhodlo vytvořri informační systém pro správu výtahů. Systém má umožňovat zobrazení stavu, nastavení a ovládaní výtahu. Systém bude přístupný pro partnerské firmy, které přímo vyrábějí výtahy.

### K ČEMU?

Systém má za úkol ulehčit výtahařským firmám správu výtahu. Jedná se hlavně sledování, kontrolu a servis jak nových, tak stávajících výtahů. Jako vedlejší činnost bude monitorování spotřeby elektrické energie, která v poslední době je palčivý problém společnosti.

### KDO?

Se systémem budou pracovat tři typu uživatelů. 

Super uživatel z naší firmy, bude mít kontrolu nad celým systémem. Mezi jeho hlavní úkoly bude patřit vytváření firem a každé firmě vytvořit pověřenou osobu, která bude dabou firmu spravovat. Dále naváděd do systému moduly, které slouži pro komunikaci mezi výtahem a systémem.

Správce firemního účtu vytváří a spravuje výtahy. Může taktéž vytvářet nové uživatele a jim nastavovat práva na výtah.

Uživatel může spravovat výtah na který má práva. Může se jednat o servisního technika, který má kontrolu nad celým výtahem, nebo o domovníka, který může jenom sledovat stav výtahu.

### VSTUPY

Výtah bude obsahovat popis jak technického tak netechnického charakteru. Adresa a uživatelský popis a z techických paratḿetrů se jedná o typ výtahu, motor, parametry aj. Každou změnu bude zasílat do systému jedná se o patra, rychlost, teplotu, spotřebu atd. 

Uživatel bude mít základní popis a typ role.

Firmy mají základní popis, tarif použivaní a správce firemního účtu.

Tarify definují jaké možnosti budou mít firmy. Počet uživatelů, výtahu a dlouho dobé ukládání dat.

Karty, typ řídíci karty a jejich popis.

Moduly mají jedinečné identifikační číslo, které bude spárováno s daným výtahem.

Parametry výtahu jako je počet stanic, typ pohonu aj.

Typy výtahu, osobní, nákladní, bez dopravy osob, plošiny.

Motory jako jsou trakční, trakční s frekvenčním řízením a hydraulické.

Chyby které nastávají na výtahu.


### VÝSTUPY

Výstupem bude popis výtahu, jeho aktuální stav a nastavení. Uživatel si může zobrazit výtahy ke kterým dostal oprávnění. Správce firemního účtu si bude moci zobrazit uživatele a výtahy.

Super uživatel bude moci zobrazit firmy, uživatele, výtahy a moduly.

### FUNKCE

Super uživatel bude moci vytvářet firmu přiřadit jí tarif a správce dané firmy. Dále spravovat moduly. 

Správce firemního účtu přidává/odebírá výtahy, uživatele a nastavuje práva uživateli práva pro konkrétní výtah.

Uživateli se zobrazují výtahy a jejich stavy. 

Všichni uživatelé mají možnost si editovat svoje údaje.

Systém příjme údaje od modulů a zpracuje je.

Systém upozorní uživatele zda je problém na výtahu.
