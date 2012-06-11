import sys
from pyquery import PyQuery as pq
import urllib2
from lxml import etree
import lxml.html
import json
import logging
import time
from datetime import datetime

import couchdb

base_url = 'http://topic.weibo.com/k/%E5%BC%A0%E5%86%A0%E6%9D%8E%E6%88%B4%E9%9F%B3%E4%B9%90%E8%8A%82'

# database
couch = couchdb.Server()
db = couch['weibo']

def main(paging = 0):
    logging.info('========>>> start working ========>>>')
    while 1:
        # delete old weibo first
        for id in db:
	    db.delete(db[id])
        # fetch 5 pages weibo
        for i in range(10):
            fetch_weibo(i)
        print 'now is: %s' % str(datetime.now())
        time.sleep(120)

def fetch_weibo(page = 0):
    url_suffix = ''
    if page > 0:
	url_suffix = "?page=%d" % page
    url = base_url + url_suffix

    parse_weibo(pq(url=url))

def parse_weibo(raw_data):
    dls = raw_data('dl[class="feed_list "]')
    print dls.size()

    for dl in dls:
	user_node = dl.xpath('./dt/a')[0]
        title = user_node.xpath('./@title')[0]
	link = user_node.xpath('./@href')[0]
	img = user_node.xpath('./img/@src')[0]
	print 'user title: %s' % title
	print 'user link: %s' % link
	print 'user image: %s' % img
	print '++++++'

	# weibo text node
	weibo_node = dl.xpath('.//p[@node-type="feed_list_content"]')[0]
	#parse_weibo_node(weibo_node)
	weibo_msg = weibo_node.text_content().strip()
	print 'weibo message: %s' % weibo_msg
	# find image
	wb_img = ''
	image_nodes = dl.xpath('.//ul[@node-type="feed_list_media_prev"]')
	if image_nodes and len(image_nodes) > 0:
	    wb_img = parse_weibo_image(image_nodes[0])
	print '++++++'
    
	# forwarded weibo
	forward_weibos = dl.xpath('.//dl[@class="comment"]')
	f_title = ''
	f_link = ''
	f_weibo = ''
	f_img = ''
	ff = ''
	fc = ''
	ft = ''
	fs = ''
	if forward_weibos and len(forward_weibos) > 0 and len(forward_weibos[0].getchildren()) > 0:
	    #print lxml.html.tostring(forward_weibos[0])
	    try:
	        f_title, f_link, f_weibo = parse_forward_weibo_message(forward_weibos[0])
		image_nodes = forward_weibos[0].xpath('.//dd[@node-type="feed_list_media_prev"]')
	        if image_nodes and len(image_nodes) > 0:
	            f_img = parse_weibo_image(image_nodes[0])
		status_node = forward_weibos[0].xpath('.//dd[@class="info W_linkb W_textb"]')[0]
		ff = status_node.xpath('.//a')[0].text_content()
		fc = status_node.xpath('.//a')[1].text_content()
		ft = status_node.xpath('.//a')[2].text_content()
		fs = status_node.xpath('.//a')[3].text_content()
		print 'forward status: %s' % ff
		print 'forward comment: %s' % fc
		print 'forward time: %s' % ft
		print 'forward source: %s' % fs
 	    except:
		logging.error('parse forward weibo text error')
	    print '++++++'

	# forward, favorite and comment status
	forward = dl.xpath('.//a[@action-type="feed_list_forward"]')[0].text_content()
	print forward
	fav =  dl.xpath('.//a[@action-type="feed_list_favorite"]')[0].text_content()
	print fav
	comment =  dl.xpath('.//a[@action-type="feed_list_comment"]')[0].text_content()
	print comment
	print '++++++'

	# post time and source
	time = dl.xpath('.//a[@node-type="feed_list_item_date"]')[0].attrib['date']
	print 'time is: %s' % time
	source = dl.xpath('.//a[@rel="nofollow"]')
	laizi = ''
	if source:
	    laizi = source[0].text_content() 
	print 'from: %s' % laizi
	print '======================='

        # write to db
        doc = {'user_title': title, 'user_link': link, 'user_image': img, 
               'weibo': weibo_msg, 'weibo_image': wb_img,
               'forward_weibo': {'title': f_title, 'link': f_link, 'weibo': f_weibo,
                           'img': f_img, 'forward': ff, 'comment': fc,
                           'time': ft, 'source': fc},
               'forward': forward, 'favorite': fav, 'comment': comment,
               'time': time, 'source': laizi}
        db.save(doc)

def parse_forward_weibo_message(node):
    weibo = node.xpath('.//dt[@node-type="feed_list_forwardContent"]')[0].text_content().strip()
    title = node.xpath('.//a')[0].attrib['title']
    link = node.xpath('.//a')[0].attrib['href']
    print 'forward user title: %s' % title
    print 'forward user link: %s' % link
    print 'forward weibo text: %s' % weibo
    return title, link, weibo

def parse_weibo_image(image_node):
    img = image_node.xpath('.//img')[0].attrib['src']
    print 'image src is: %s' % img
    return img

if __name__ == "__main__":
    main()
