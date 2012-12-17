# -*- coding: utf-8 -*-
import re

from pyramid.httpexceptions import (
    HTTPFound,
    HTTPNotFound,
    )

from pyramid.view import view_config

from .models import (
    DBSession,
    Post,
    )

from markupsafe import Markup, escape, soft_unicode

re_match_urls = re.compile(ur"""((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[. ][a-z]{2,4}/)(?:[^\s()<>]+|(([^\s()<>]+|(([^\s()<>]+)))*))+(?:(([^\s()<>]+|( ([^\s()<>]+)))*)|[^\s`!()[]{};:'".,<>?«»“”‘’]))""", re.DOTALL | re.UNICODE)

def format_post(text):
    text = re.sub(r'\r\n', r'\\r\\n', text)
    text = unicode(escape(text))
    text = re.sub(r'\\r\\n', r'<br/>', text)
    text = re.sub(r'(.*?)(&gt;&gt;)([\d]*)(.*?)', r'\1<a href = "/#\3">\2\3</a>\4', text)
    text = re_match_urls.sub(lambda x: u'<a href="%(url)s">%(url)s</a>' % dict(url=unicode(x.group())), text)    
    return text

@view_config(route_name = 'view_thread', renderer = 'thread.mako')
def view_thread(request):

    if 'form.submitted' in request.params:
        body = request.params['body']
        formatted_text = format_post(body)
        if formatted_text == '':
            return HTTPFound(location = '/#footer')
        post = Post(body)            
        post.formatted_text = formatted_text
        DBSession.add(post)
        return HTTPFound(location = '/#footer')

    content = DBSession.query(Post).all()

    return dict(pages = content)

'''
wikiwords = re.compile(r"\b([A-Z]\w+[A-Z]+\w+)")
@view_config(route_name='view_wiki')
def view_wiki(request):
    return HTTPFound(location = request.route_url('view_page', pagename='FrontPage'))

@view_config(route_name='view_page', renderer='templates/view.pt')
def view_page(request):
    pagename = request.matchdict['pagename']
    page = DBSession.query(Page).filter_by(name=pagename).first()

    if page is None:
        return HTTPNotFound('No such page')

    def check(match):
        word = match.group(1)
        exists = DBSession.query(Page).filter_by(name=word).all()
        if exists:
            view_url = request.route_url('view_page', pagename=word)
            return '<a href="%s">%s</a>' % (view_url, word)
        else:
            add_url = request.route_url('add_page', pagename=word)
            return '<a href="%s">%s</a>' % (add_url, word)

    content = publish_parts(page.data, writer_name='html')['html_body']
    content = wikiwords.sub(check, content)
    edit_url = request.route_url('edit_page', pagename=pagename)
    return dict(page=page, content=content, edit_url=edit_url)

@view_config(route_name='add_page', renderer='templates/edit.pt')
def add_page(request):
    pagename = request.matchdict['pagename']
    if 'form.submitted' in request.params:
        body = request.params['body']
        page = Page(pagename, body)
        DBSession.add(page)
        return HTTPFound(location = request.route_url('view_page', pagename=pagename))

    save_url = request.route_url('add_page', pagename=pagename)
    page = Page('', '')
    return dict(page=page, save_url=save_url)

@view_config(route_name='edit_page', renderer='templates/edit.pt')
def edit_page(request):
    pagename = request.matchdict['pagename']
    page = DBSession.query(Page).filter_by(name=pagename).one()
    if 'form.submitted' in request.params:
        page.data = request.params['body']
        DBSession.add(page)
        return HTTPFound(location = request.route_url('view_page', pagename = pagename))

    return dict( page = page, save_url = request.route_url('edit_page', pagename = pagename),)
'''