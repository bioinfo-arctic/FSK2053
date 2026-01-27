## Crabs example of building a reference database

#####################################
### Instructions and introduction ###
#####################################

## Technical consideration: We need to get a crabs installation up and running on the Azure server.

## Imagine Norway has a total of e.g. 50 fish species present in territorial waters. 

### Pre-curation
## Our authoritative taxonomy is Catalog of Fishes 
## Include examples of synonymy (which should be fixed during pre-curation)
## Include examples of misidentified specimens (which should be excluded/blacklisted during pre-curation)
## Include examples of species missing barcodes (which we cannot fix bioinformatically)
## Include examples of barcode overlap (general problem with the marker chosen)
## Include examples of perfect taxonomic resolution (sometimes it works really well)

## Hybrids
## Subspecies?
## Ambiguous basepairs?
## Reinstating barcodes that do not pass criteria

### Post-curation checks
## Fill in a premade sheet of species characteristics in terms of the database (exercise for students)
## Follow up questions with some information about primer mismatches and likelihoods of detection?
## Provide some sequence data and ask what species are present in the eDNA samples (ask students to discuss our limitations here after the exercise)


############################
### Exercise walkthrough ###
############################













## Examples of groups of fishes present in Nordic countries
#### Table of ..

| Class          | Order              | Family               | Subfamily         | Species                           | Common name                   | Known synonyms                                            |
|----------------|--------------------|----------------------|-------------------|-----------------------------------|-------------------------------|-----------------------------------------------------------|
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Amblyraja hyperborea*            | Arctic skate                  |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Amblyraja jenseni*               | Shorttail skate               |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Amblyraja radiata*               | Starry ray                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Dipturus batis*                  | Blue skate                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Dipturus intermedius*            |                               |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Dipturus nidarosiensis*          | Norwegian skate               |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Dipturus oxyrinchus*             | Longnosed skate               |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Leucoraja circularis*            | Sandy ray                     |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Leucoraja fullonica*             | Shagreen ray                  |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Leucoraja naevus*                | Cuckoo ray                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Malacoraja kreffti*              | Krefft's ray                  |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Malacoraja spinacidermis*        | Soft skate                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Neoraja caerulea*                | Blue ray                      |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Raja brachyura*                  | Blonde ray                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Raja clavata*                    | Thornback ray                 |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Raja montagui*                   | Spotted ray                   |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Rajella bathyphila*              | Deep-water ray                |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Rajella bigelowi*                | Bigelow's ray                 |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Rajella fyllae*                  | Round ray                     |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Rajella lintea*                  | Sailray                       | *Dipturus linteus*                                        |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Chimaera monstrosa*              | Rabbit fish                   |                                                           |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Chimaera opalescens*             | Opal chimaera                 |                                                           |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Hydrolagus affinis*              | Smalleyed rabbitfish          |                                                           |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Hydrolagus mirabilis*            | Large-eyed rabbitfish         |                                                           |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Hydrolagus pallidus*             |                               |                                                           |
| Holocephali    | Chimaeriformes     | Rhinochimaeridae     |                   | *Harriotta raleighana*            | Pacific longnose chimaera     | *Harriotta haeckeli*                                      |
| Holocephali    | Chimaeriformes     | Rhinochimaeridae     |                   | *Rhinochimaera atlantica*         | Straightnose rabbitfish       |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Barbantus curvifrons*            | Palebelly searsid             |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Holtbyrnia anomala*              | Bighead searsid               |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Holtbyrnia macrops*              | Bigeye searsid                |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Maulisia mauli*                  | Maul's searsid                |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Maulisia microlepis*             | Smallscale searsid            |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Normichthys operosus*            | Multipore searsid             | *Normichthys operosa*                                     |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Platytroctes apus*               | Legless searsid               |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Platytroctes mirus*              | Leaf searsid                  |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Sagamichthys schnakenbecki*      | Schnakenbeck's searsid        |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Searsia koefoedi*                | Koefoed's searsid             |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus albula*                | Vendace                       |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus artedi*                | Cisco                         |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus clupeaformis*          | Lake whitefish                |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus lavaretus*             | European whitefish            |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus maraena*               | Maraena whitefish             |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus maxillaris*            |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus megalops*              | Lacustrine fluvial whitefish  |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus nilssoni*              |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus oxyrinchus*            | Houting                       |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus pallasii*              |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus peled*                 | Peled                         |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus pidschian*             | Humpback whitefish            |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus trybomi*               |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus widegreni*             | Valaam whitefish              |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Thymallinae       | *Thymallus thymallus*             | Grayling                      |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus clarkii*            | Cutthroat trout               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus gorbuscha*          | Pink salmon                   |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus keta*               | Chum salmon                   |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus kisutch*            | Coho salmon                   |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus mykiss*             | Rainbow trout                 |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus nerka*              | Sockeye salmon                |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salmo salar*                     | Atlantic salmon               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salmo trutta*                    | Sea trout                     |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus alpinus*              | Arctic char                   | *Salvelinus umbla*                                        |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus faroensis*            |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus fontinalis*           | Brook trout                   |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus lepechini*            |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus murta*                |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus namaycush*            | Lake trout                    |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus salvelinoinsularis*   | Bear Island charr             |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus thingvallensis*       |                               |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Gymnoscopelinae   | *Notoscopelus kroyeri*            | Lancet fish                   |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Ceratoscopelus maderensis*       | Madeira lantern fish          |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampadena speculigera*           | Mirror lanternfish            |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampanyctus ater*                | Dusky lanternfish             | *Nannobrachium atrum*                                     |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampanyctus crocodilus*          | Jewel lanternfish             |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampanyctus intricarius*         | Diamondcheek lanternfish      |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampanyctus macdonaldi*          | Rakery beaconlamp             |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Diaphinae         | *Diaphus rafinesquii*             | White-spotted lantern fish    |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Myctophinae       | *Benthosema glaciale*             | Glacier lantern fish          |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Myctophinae       | *Myctophum punctatum*             | Spotted lanternfish           |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Myctophinae       | *Protomyctophum arcticum*         | Arctic telescope              |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Myctophinae       | *Symbolophorus veranyi*           | Large-scale lantern fish      |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Arctogadus glacialis*            | Arctic cod                    |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Boreogadus saida*                | Polar cod                     |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Eleginus nawaga*                 | Navaga                        |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadiculus argenteus*             | Silvery pout                  | *Gadiculus thori*                                         |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadus chalcogrammus*             | Norwegian pollock             | *Gadus finnmarchicus*, *Theragra chalcogramma*, *Theragra finnmarchica* |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadus macrocephalus*             | Pacific cod                   | *Gadus ogac*, despite Eschmeyer not listing it            |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadus morhua*                    | Atlantic cod                  |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Melanogrammus aeglefinus*        | Haddock                       |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Merlangius merlangus*            | Whiting                       |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Micromesistius poutassou*        | Blue whiting                  |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Pollachius pollachius*           | Pollack                       |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Pollachius virens*               | Saithe                        |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Trisopterus esmarkii*            | Norway pout                   |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Trisopterus luscus*              | Pouting                       |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Trisopterus minutus*             | Poor cod                      |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Artediellus atlanticus*          | Atlantic hookear sculpin      |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Artediellus scaber*              | Hamecon                       |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Artediellus uncinatus*           | Arctic hookear sculpin        |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Cottunculus microps*             | Polar sculpin                 |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Cottunculus subspinosus*         |                               | *Psychrolutes subspinosus*                                |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Cottunculus thomsonii*           | Pallid sculpin                |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Gymnocanthus tricuspis*          | Arctic staghorn sculpin       |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Icelus bicornis*                 | Twohorn sculpin               |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Icelus spatula*                  | Spatulate sculpin             |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Micrenophrys lilljeborgii*       | Norway bullhead               |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Myoxocephalus quadricornis*      | Fourhorn sculpin              |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Myoxocephalus scorpioides*       | Arctic sculpin                |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Myoxocephalus scorpius*          | Shorthorn sculpin             |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Taurulus bubalis*                | Longspined bullhead           |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Triglops murrayi*                | Moustache sculpin             |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Triglops nybelini*               | Bigeye sculpin                |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Triglops pingelii*               | Ribbed sculpin                |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Careproctus kidoi*               | Kido's snailfish              |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Careproctus micropus*            | Small-eye tadpole             | *Careproctus latiosus*, *Careproctus moskalevi*, *Careproctus mica* |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Careproctus reinhardti*          | Sea tadpole                   | *Careproctus longipinnis*, *Careproctus solidus*, *Careproctus dubius* |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis bathyarcticus*           |                               |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis fabricii*                | Gelatinous snailfish          |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis gibbus*                  | Variegated snailfish          |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis liparis*                 | Striped seasnail              |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis montagui*                | Montagus seasnail             |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis tunicatus*               | Kelp snailfish                |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Paraliparis bathybius*           | Black seasnail                |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Paraliparis copei*               | Blacksnout seasnail           |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Paraliparis garmani*             | Pouty seasnail                |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Paraliparis hystrix*             |                               |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos christinae*              | European dwarf snailfish      |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos gelatinosus*             | Gelatinous dwarf snailfish    |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos groenlandicus*           | Greenland dwarf snailfish     |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos islandicus*              |                               |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos melanocephalus*          |                               |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos micruroides*             | Multipore dwarf snailfish     |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Rhodichthys melanocephalus*      | Blackhead strainer snailfish  |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Rhodichthys regina*              | Threadfin seasnail            |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys alba*                |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys kolthoffi*           | Checkered wolf eel            |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys muraena*             | Moray wolf eel                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys paxillus*            | Common wolf eel               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys platyrhina*          |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys sarsii*              | Sar's wolf eel                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes adolfi*                  | Adolf's eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes esmarkii*                | Greater eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes eudipleurostictus*       | Doubleline eelpout            |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes frigidus*                | Glacial eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes gracilis*                |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes luetkenii*               | Lütken's eelpout              |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes mcallisteri*             | McAllister's eelpout          |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes mucosus*                 | Saddled eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes paamiuti*                | Paamiut eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes pallidus*                | Pale eelpout                  |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes polaris*                 | Canadian eelpout              |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes reticulatus*             | Arctic eelpout                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes rossi*                   | Threespot eelpout             |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes seminudus*               | Longear eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes squamiventer*            | Scalebelly eelpout            |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes terraenovae*             |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes turneri*                 | Polar eelpout                 |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes vahlii*                  | Vahl's eelpout                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodonus flagellicauda*         |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodonus mirabilis*             | Chevron scutepout             |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Pachycara microcephalum*         |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Zoarcinae         | *Zoarces viviparus*               | Eelpout                       |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Gymnelinae        | *Gymnelus retrodorsalis*          | Aurora unernak                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Gymnelinae        | *Gymnelus viridis*                | Fish doctor                   |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Gymnelinae        | *Melanostigma atlanticum*         | Atlantic soft pout            |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Chaenophryne draco*              | Smooth dreamer                |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Chaenophryne longiceps*          | Can-opener smoothdream        |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Danaphryne nigrifilis*           |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Dolopichthys longicornis*        |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Leptacanthichthys gracilispinis* | Plainchin dreamarm            |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Lophodolos acanthognathus*       | Whalehead dreamer             |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes anisacanthus*          |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes carlsbergi*            |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes eschrichtii*           | Bulbous dreamer               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes macrosteus*            |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes myrionemus*            |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Phyllorhinichthys balushkini*    |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Phyllorhinichthys micractis*     |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Spiniphryne gladisfenae*         | Prickly dreamer               |                                                           |
