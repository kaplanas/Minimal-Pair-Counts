from urllib import request
from bs4 import BeautifulSoup, NavigableString
from starling_urls import *
import re
import time

# Download all the languages from a top-level language group (as hypothesized by
# the Tower of Babel group).
# These are stored in `starling_urls.py` (e.g., nostratic, afro_asiatic).
def download_database(db):
    for subdb in db['sub_databases']:
        print(subdb)
        scrape_pages(outfile_name = db['outfile_name'] + '.txt', sub_database = subdb, **db['sub_databases'][subdb])

# Starting with the url provided in the argument, scrape that page for data and
# any subsequent pages.
# The total number of pages to expect is hard-coded in `starling_urls.py`.  It
# would be more robust to retrieve this information from the webpage directly,
# but there were few enough pages total that it didn't take long to record the
# information, and it doesn't seem worth it to go back and change things now.
def scrape_pages(start_url, outfile_name, num_words, num_pages, sub_database):
    page = BeautifulSoup(request.urlopen(start_url).read().decode(), 'lxml')
    for i in range(0, num_pages):
        print(i)
        # Scrape the information from the current page.
        scrape_page(page, outfile_name, num_words, sub_database)
        # Get the url of the next page.
        new_link = get_next_link(page)
        # Get the next page.
        got_page = False
        while not got_page:
            try:
                page = BeautifulSoup(request.urlopen(new_link).read().decode(), 'lxml')
                got_page = True
            except:
                print('waiting...')
                time.sleep(3)

# From one page of search results, get the url of the next page.
def get_next_link(page):
    temp_link = ''
    found_pages = False
    use_next = False
    for item in page.contents[0].contents[2].contents:
        if use_next and not isinstance(item, NavigableString) and\
           'href' in item.attrs:
            return('http://starling.rinet.ru/cgi-bin/' + item['href'])
        elif found_pages and not isinstance(item, NavigableString) and\
           'href' in item.attrs and temp_link == '':
            temp_link = 'http://starling.rinet.ru/cgi-bin/' + item['href']
        elif found_pages and not isinstance(item, NavigableString) and\
             'color' in item.attrs:
            use_next = True
        elif str(item).startswith('Pages:'):
            found_pages = True
    return(temp_link)

# Scrape wordlists from a page of search results.
def scrape_page(page, outfile_name, num_words, sub_database):
    # Iterate over all of the items in the page.
    for result in page.find_all('div'):
        # Get the language.  Assume that it's the name of a language only if
        # it's followed by a colon (which is removed in the output).
        spans = result.find_all('span')
        if len(spans) > 1:
            language = spans[0].string
            if language[-1] == ':':
                language = language[:-1]
                if language == 'Entry':
                    language = sub_database
                # Get the word; remove everything after a space or punctuation
                # mark.  Print the entry if it's not a reconstruction.
                word = spans[1].string
                if word is not None and len(word) > 0:
                    word = ' '.join(word.split(' ')[:num_words])
                    if len(word) > 0 and not word[0] == '*':
                        print_entry(outfile_name, language, word)

# Write the word to a file.
def print_entry(outfile_name, l, w):
    out_file = open(outfile_name, 'a')
    out_file.write(l)
    out_file.write('\t')
    out_file.write(w)
    out_file.write('\n')
    out_file.close()
