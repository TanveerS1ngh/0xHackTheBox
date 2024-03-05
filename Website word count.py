import requests
import re
from bs4 import BeautifulSoup

PAGE_URL = 'http://94.237.55.163:38839'

def get_html_of(url):
    resp = requests.get(url)

    if resp.status_code != 200:
        print(f'HTTP status code of {resp.status_code} returned, but 200 was expected. Exiting...')
        exit(1)

    return resp.content.decode()

html = get_html_of(PAGE_URL)
soup = BeautifulSoup(html, 'html.parser')
raw_text = soup.get_text()
all_words = re.findall(r'\w+', raw_text)

word_count = {}

for word in all_words:
    if word not in word_count:
        word_count[word] = 1
    else:
        current_count = word_count.get(word)
        word_count[word] = current_count + 1

top_words = sorted(word_count.items(), key=lambda item: item[1], reverse=True)

for i in range(10):
    print(top_words[i][0])


# Here's a breakdown of what the script does:

# Imports: The script imports necessary modules:

# requests: Used for making HTTP requests.
# re: Regular expression module for pattern matching.
# BeautifulSoup: Used for parsing HTML and extracting data from HTML documents.
# Variables:

# PAGE_URL: Specifies the URL to which HTTP requests will be made.
# Function get_html_of(url):

# Sends an HTTP GET request to the specified url using the requests.get() function.
# Checks if the response status code is 200 (OK). If not, it prints an error message and exits the script.
# Returns the decoded content of the response.
# Main Script:

# Calls the get_html_of() function with the PAGE_URL variable to retrieve the HTML content of the page.
# Uses BeautifulSoup to parse the HTML content and extract text from it.
# Uses a regular expression (re.findall()) to find all words in the extracted text.
# Counts the occurrences of each word and stores them in a dictionary (word_count).
# Sorts the words based on their counts and prints the top 10 most frequent words.
# Overall, the script fetches HTML content from a specified URL, extracts text from it, and then counts the occurrences of each word in the text. Finally, it prints the top 10 most frequent words found in the text.