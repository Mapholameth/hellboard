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

def format_post(post):
    text = post.text
    text = re.sub(ur'\r\n', ur'\\r\\n', text)
    text = unicode(escape(text))
    text = re.sub(ur'\\r\\n', ur'<br/>', text)
    text = re.sub(ur'(.*?)(&gt;&gt;)([\d]+)(.*?)', ur'\1<a class="post-link" data-parent-id="%(id)s" data-target-id="\3" href = "/#\3">\2\3</a>\4', text, re.UNICODE)
    text = text % dict(id=post.id)
    text = re_match_urls.sub(lambda x: u'<a href="%(url)s">%(url)s</a>' % dict(url=unicode(x.group())), text)
    if text == u"":
        return False
    post.formatted_text = text
    return True

def reformat_posts():
    content = DBSession.query(Post).all()
    for post in content:
        format_post(post)

@view_config(route_name = 'view_thread', renderer = 'thread.mako')
def view_thread(request):

    if 'form.submitted' in request.params:
        post = Post(request.params['body'])
        DBSession.add(post)
        DBSession.flush()
        if not format_post(post):
            DBSession.delete(post)
        return HTTPFound(location = '/#footer')

    if 'reformat-posts' in request.params:
        reformat_posts()
        return HTTPFound(location = '/#footer')

    if 'delete-post' in request.params:
        id = request.params['delete-post']
        post = DBSession.query(Post).filter_by(id = id).one()
        DBSession.delete(post)
        return HTTPFound(location = '/#footer')

    content = DBSession.query(Post).all()

    return dict(pages = content)
