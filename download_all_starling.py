from starling_urls import *
from download_starling import *

starling_databases = [nostratic, afro_asiatic, sino_caucasian, austric, macro_khoisan]
for database in starling_databases:
    download_database(database)
