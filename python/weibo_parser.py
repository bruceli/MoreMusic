import sys
from pyquery import PyQuery as pq
import urllib2
from lxml import etree
import json
import logging

base_url = 'http://topic.weibo.com/k/%E5%BC%A0%E5%86%A0%E6%9D%8E%E6%88%B4%E9%9F%B3%E4%B9%90%E8%8A%82'

def main(paging = 0):
    logging.info('========>>> start working ========>>>')
    url_suffix = ''
    if paging > 0:
	url_suffix = "?page=%d" % paging
    
    url = base_url + url_suffix

    raw_data = pq(url=url)
    dls = raw_data('dl[class="feed_list "]')
    print dls.size()

    for dl in dls:
	face = dl.find('dt').class('face')
        print face

if __name__ == "__main__":
    main()
