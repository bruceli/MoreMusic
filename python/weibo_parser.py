import sys
from pyquery import PyQuery as pq
import urllib2
from lxml import etree
import lxml.html
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
	weibo_message = weibo_node.text_content()
	print 'weibo message: %s' % weibo_message
	# find image
	image_nodes = dl.xpath('.//ul[@node-type="feed_list_media_prev"]')
	if image_nodes and len(image_nodes) > 0:
	    parse_weibo_image(image_nodes[0])
	print '++++++'
    
	# forwarded weibo
	forward_weibos = dl.xpath('.//dl[@class="comment"]')
	if forward_weibos and len(forward_weibos) > 0 and len(forward_weibos[0].getchildren()) > 0:
	    #print lxml.html.tostring(forward_weibos[0])
	    try:
	        parse_weibo_message(forward_weibos[0])
		image_nodes = forward_weibos[0].xpath('.//dd[@node-type="feed_list_media_prev"]')
	        if image_nodes and len(image_nodes) > 0:
	            parse_weibo_image(image_nodes[0])
		status_node = forward_weibos[0].xpath('.//dd[@class="info W_linkb W_textb"]')[0].text_content()
		print 'forward status: %s' % status_node
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
	if source:
	    laizi = source[0].text_content() 
	print 'from: %s' % laizi
	print '======================='

def parse_weibo_message(node):
    weibo = node.xpath('.//dt[@node-type="feed_list_forwardContent"]')[0].text_content()
    title = node.xpath('.//a')[0].attrib['title']
    link = node.xpath('.//a')[0].attrib['href']
    print 'forward user title: %s' % title
    print 'forward user link: %s' % link
    print 'forward weibo text: %s' % weibo

def parse_weibo_image(image_node):
    img = image_node.xpath('.//img')[0].attrib['src']
    print 'image src is: %s' % img

if __name__ == "__main__":
    main()
