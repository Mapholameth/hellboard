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
    Thread,
    Board,
    )

from markupsafe import Markup, escape, soft_unicode

from sqlalchemy.orm.exc import NoResultFound

from sqlalchemy import desc

re_match_urls = re.compile(ur"""(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))""", re.DOTALL | re.UNICODE)

#(([(]*)(?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[. ][a-z]{2,4}/)(?:[^\s()<>]+|(([^\s()<>]+|(([^\s()<>]+)))*))+(?:(([^\s()<>]+|( ([^\s()<>]+)))*)|[^\s`!()[]{};:'".,<>?«»“”‘’]))

# temp snippet for get utc unix timestamp
# from datetime import datetime
# import calendar
# calendar.timegm(datetime.utcnow().utctimetuple())
# utc unixtimestamp interpolated with milliseconds
# unicode(calendar.timegm(datetime.utcnow().utctimetuple())) + unicode(datetime.utcnow().microsecond/1000)

def format_post(post):
    text = post.text
    text = re.sub(ur'\r\n', ur'\\r\\n', text)
    text = unicode(escape(text))
    text = re.sub(ur'\\r\\n', ur'<br/>', text)
    text = re.sub(ur'(.*?)(&gt;&gt;)([\d]+)(.*?)', ur'\1<a class="post-link" data-parent-id="' + unicode(post.id) + ur'" data-target-id="\3" href = "/#\3">\2\3</a>\4', text, flags = re.UNICODE)

    def url_match_process_group(group):
        head = u""
        tail = u""
        body = group

        # m = re.match(ur"^([(]*)(.*)", body, flags = re.DOTALL | re.UNICODE)
        # if m != None:
        #     head += m.group(1)
        #     body = m.group(2)

        # m = re.match(ur"(.*)([.,?!])$", body, flags = re.DOTALL | re.UNICODE)
        # if m != None:
        #     tail = m.group(2) + tail
        #     body = m.group(1)

        return dict(head = head, url = body, tail = tail)

    text = re_match_urls.sub(lambda x: u'%(head)s<a href="%(url)s">%(url)s</a>%(tail)s' % url_match_process_group(unicode(x.group())), text)

    if text == u"":
        return False
    post.formatted_text = text
    return True

def reformat_posts():
    content = Post.GetAll()
    for post in content:
        format_post(post)

@view_config(route_name = 'view_root', renderer = 'root.mako')
def view_root(request):
    boards = Board.GetAll()
    return dict(boards = boards)

@view_config(route_name = 'view_board', renderer = 'board.mako')
def view_board(request):
    boards = Board.GetAll()
    boardName = request.matchdict['board']

    try:
        board = DBSession.query(Board).filter_by(name = boardName).one()
    except NoResultFound:
        return HTTPNotFound()

    threads = DBSession.query(Thread).filter_by(boardId = board.id).all()
    content = []
    for item in threads:
        posts = DBSession.query(Post).filter_by(threadId = item.id).all()
        newThread = dict()
        newThread['thread'] = item
        newThread['posts'] = posts
        content = content + [ newThread ]
    return dict(threads = content, boards = boards)

@view_config(route_name = 'view_thread', renderer = 'thread.mako')
def view_thread(request):
    boards = DBSession.query(Board).all()
    try:
        board = DBSession.query(Board).filter_by(name = request.matchdict['board']).one()
        thread = DBSession.query(Thread).filter_by(id = request.matchdict['thread']).one()
    except NoResultFound:
        return HTTPNotFound()

    url = request.route_url('view_thread', board = board.name, thread = unicode(thread.id))

    if 'form.submitted' in request.params:
        post = Post(request.params['body'], board.id, thread.id)
        DBSession.add(post)
        DBSession.flush()
        if not format_post(post):
            DBSession.delete(post)
        return HTTPFound(location = url)

    if 'reformat-posts' in request.params:
        reformat_posts()
        return HTTPFound(location = url)

    if 'delete-post' in request.params:
        id = request.params['delete-post']
        post = DBSession.query(Post).filter_by(id = id).one()
        DBSession.delete(post)
        return HTTPFound(location = url)

    content = DBSession.query(Post).filter_by(threadId = thread.id, boardId = board.id).order_by(Post.id).all()

    return dict(posts = content, boards = boards)

@view_config(route_name = 'view_post', renderer = 'thread.mako')
def view_post(request):
    boards = DBSession.query(Board).all()
    board = DBSession.query(Board).filter_by(name = request.matchdict['board']).one()
    thread = DBSession.query(Thread).filter_by(id = request.matchdict['thread']).one()
    post = DBSession.query(Post).filter_by(id = request.matchdict['post']).all()
    if len(post) == 0:
        return HTTPNotFound()
    return dict(posts = post, boards = boards)